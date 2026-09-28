import { useCallback, useEffect, useMemo, useRef, useState, type CSSProperties } from "react";
import Editor, { type Monaco } from "@monaco-editor/react";
import { name as initialName, source as initialScad } from "virtual:scad";
import { files as scadCatalog, defaultName as catalogDefault } from "virtual:scad-catalog";
import { applyVarsToSource, applyVarToSource, parseCustomizer, type Param, type Vars } from "./customizer";
import { formatDiag, parseOpenScadDiagnostics, sameFile, type Diag } from "./diagnostics";
import { Viewer } from "./Viewer";
import { formatMm, sheetCutList } from "./sheetCut";
import {
  defaultProject,
  encodeText,
  fileText,
  isSingleScad,
  loadProjectFromUrl,
  MAX_SHARE_URL,
  pickCatalogFile,
  readVarsFromParams,
  requestedCatalogFile,
  clearShareUrl,
  scadPaths,
  shareUrl,
  syncProjectUrl,
} from "./project";

type Job = {
  id: number;
  preview: boolean;
};

type Theme = "light" | "dark";
const THEME_KEY = "drillbox-theme";
const EDITOR_WIDTH_KEY = "drillbox-editor-ratio";
const MODEL_KEY = "drillbox-selected-model";

function savedModel() {
  try { return localStorage.getItem(MODEL_KEY) ?? ""; }
  catch { return ""; }
}

function rememberModel(name: string) {
  try { localStorage.setItem(MODEL_KEY, name); }
  catch { /* The URL still preserves the selection without storage. */ }
}

function readEditorRatio() {
  try {
    const value = Number(localStorage.getItem(EDITOR_WIDTH_KEY));
    if (Number.isFinite(value) && value > 0 && value < 1) return value;
  } catch { /* Storage may be unavailable. */ }
  return 1 / 2.3;
}

function readTheme(): Theme {
  try {
    const stored = localStorage.getItem(THEME_KEY);
    if (stored === "light" || stored === "dark") return stored;
  } catch {
    /* ignore */
  }
  return "light";
}

function applyTheme(theme: Theme) {
  document.documentElement.dataset.theme = theme;
  try {
    localStorage.setItem(THEME_KEY, theme);
  } catch {
    /* ignore */
  }
}

function catalogNames() {
  return Object.keys(scadCatalog).sort((a, b) => a.localeCompare(b, undefined, { sensitivity: "base" }));
}

function bootModel() {
  return (
    pickCatalogFile(scadCatalog, requestedCatalogFile()) ??
    pickCatalogFile(scadCatalog, savedModel()) ??
    pickCatalogFile(scadCatalog, catalogDefault) ??
    pickCatalogFile(scadCatalog, initialName) ?? { name: initialName, source: initialScad }
  );
}

function readBoot() {
  const fromUrl = loadProjectFromUrl();
  const vars =
    fromUrl?.vars && Object.keys(fromUrl.vars).length ? fromUrl.vars : readVarsFromParams();
  let project = fromUrl;
  let error: string | null = null;
  if (!fromUrl) {
    const model = bootModel();
    project = defaultProject(model.source, model.name);
  } else if (fromUrl.error || !Object.keys(fromUrl.files).length) {
    const model = bootModel();
    project = defaultProject(model.source, model.name);
    error = fromUrl.error ?? "Could not read URL parameter";
  }
  const files = project!.files;
  const main = project!.main;
  if (Object.keys(vars).length && files[main]) {
    const patched = applyVarsToSource(fileText(files, main), vars);
    return {
      project: { files: { ...files, [main]: encodeText(patched) }, main, vars },
      error,
    };
  }
  return { project: { files, main, vars }, error };
}

export function App() {
  const [boot] = useState(readBoot);
  const [files, setFiles] = useState(boot.project.files);
  const [main, setMain] = useState(boot.project.main);
  const [openPath, setOpenPath] = useState(boot.project.main);
  const [vars, setVars] = useState<Vars>(boot.project.vars ?? {});
  const [stl, setStl] = useState<ArrayBuffer | null>(null);
  const [parts, setParts] = useState<ArrayBuffer[] | null>(null);
  const [status, setStatus] = useState(boot.error ?? "Loading WASM…");
  const [err, setErr] = useState(Boolean(boot.error));
  const [busy, setBusy] = useState(false);
  const [diags, setDiags] = useState<Diag[]>([]);
  const [theme, setTheme] = useState<Theme>(readTheme);
  const [editorRatio, setEditorRatio] = useState(readEditorRatio);
  const [resizing, setResizing] = useState(false);
  const workRef = useRef<HTMLDivElement>(null);
  const dragOffset = useRef(0);

  useEffect(() => {
    try { localStorage.setItem(EDITOR_WIDTH_KEY, String(editorRatio)); }
    catch { /* Resizing still works without storage. */ }
  }, [editorRatio]);

  function resizeEditor(width: number) {
    const available = (workRef.current?.clientWidth ?? 0) - 306;
    if (available < 600) return;
    setEditorRatio(Math.max(280, Math.min(available - 320, width)) / available);
  }
  const job = useRef<Job & { worker?: Worker }>({ id: 0, preview: true });
  const debounce = useRef<number>(0);
  const urlDebounce = useRef<number>(0);
  const skipUrlSync = useRef(true);
  const editorRef = useRef<{
    revealLineInCenter: (line: number) => void;
    setPosition: (pos: { lineNumber: number; column: number }) => void;
    getModel: () => { getLineCount: () => number; getLineLength: (line: number) => number } | null;
  } | null>(null);
  const monacoRef = useRef<Monaco | null>(null);

  const source = fileText(files, openPath);
  const mainSource = fileText(files, main);
  const paths = useMemo(() => scadPaths(files), [files]);
  const params = useMemo(() => parseCustomizer(mainSource), [mainSource]);
  const title = (main.split("/").pop() ?? "OpenSCAD").replace(/\.scad$/i, "");
  const part = String(vars.part ?? params.find((p) => p.name === "part")?.initial ?? "assembly");
  const grouped = useMemo(() => {
    const g: Record<string, Param[]> = {};
    for (const p of params) {
      if (p.name === "lid_open" && part !== "assembly") continue;
      (g[p.group] ??= []).push(p);
    }
    return g;
  }, [params, part]);
  const previewVars = useMemo(() => {
    const next: Vars = {};
    for (const p of params) next[p.name] = p.initial;
    return { ...next, ...vars };
  }, [params, vars]);
  const sheet = useMemo(() => sheetCutList(vars, params), [vars, params]);

  const run = useCallback(
    (preview: boolean, now = false) => {
      window.clearTimeout(debounce.current);
      const start = () => {
        job.current.worker?.terminate();
        const id = job.current.id + 1;
        job.current = { id, preview };
        setBusy(true);
        setErr(false);
        setStatus(preview ? "Preview…" : "Render…");
        const worker = new Worker(`${import.meta.env.BASE_URL}openscad-worker.js?v=4`, {
          type: "module",
        });
        job.current.worker = worker;
        worker.onmessage = (ev: MessageEvent) => {
          if (ev.data.id !== id) return;
          worker.terminate();
          if (job.current.worker === worker) job.current.worker = undefined;
          setBusy(false);
          if (!ev.data.ok) {
            setErr(true);
            const parsed = parseOpenScadDiagnostics(
              `${ev.data.error || ""}\n${ev.data.log || ""}`,
              main,
              Object.keys(files)
            );
            setDiags(parsed);
            const first = parsed[0];
            setStatus(first ? formatDiag(first) : ev.data.error || "OpenSCAD error");
            return;
          }
          setStl(ev.data.stl);
          setParts(ev.data.parts ?? null);
          setErr(false);
          setDiags([]);
          setStatus(preview ? "Preview ready" : "Render ready");
        };
        worker.onerror = (e) => {
          if (job.current.id !== id) return;
          setBusy(false);
          setErr(true);
          setStatus(e.message || "Worker error");
        };
        worker.postMessage({ id, files, main, vars: { ...vars, part }, preview });
      };
      if (now) start();
      else debounce.current = window.setTimeout(start, 700);
    },
    [files, main, vars, part]
  );

  useEffect(() => {
    const first = diags[0];
    if (first && files[first.file] && !sameFile(first.file, openPath)) {
      setOpenPath(first.file);
    }
  }, [diags, files, openPath]);

  useEffect(() => {
    const monaco = monacoRef.current;
    const ed = editorRef.current;
    const model = ed?.getModel();
    if (!monaco || !ed || !model) return;
    const here = diags.filter((d) => sameFile(d.file, openPath));
    const count = model.getLineCount();
    monaco.editor.setModelMarkers(
      model,
      "openscad",
      here.map((d) => {
        const line = Math.min(Math.max(1, d.line), count);
        const len = model.getLineLength(line);
        return {
          startLineNumber: line,
          startColumn: 1,
          endLineNumber: line,
          endColumn: Math.max(2, len + 1),
          message: d.message,
          severity: monaco.MarkerSeverity.Error,
        };
      })
    );
    if (here[0]) {
      const line = Math.min(Math.max(1, here[0].line), count);
      ed.revealLineInCenter(line);
      ed.setPosition({ lineNumber: line, column: 1 });
    }
  }, [diags, openPath, source]);

  useEffect(() => {
    if (!isSingleScad(files)) return;
    window.clearTimeout(urlDebounce.current);
    urlDebounce.current = window.setTimeout(() => {
      if (skipUrlSync.current && !Object.keys(vars).length) {
        skipUrlSync.current = false;
        return;
      }
      skipUrlSync.current = false;
      syncProjectUrl(files, main, vars, scadCatalog);
    }, 350);
    return () => window.clearTimeout(urlDebounce.current);
  }, [files, main, vars]);

  useEffect(() => {
    applyTheme(theme);
  }, [theme]);

  useEffect(() => {
    run(true, false);
    return () => {
      window.clearTimeout(debounce.current);
      job.current.worker?.terminate();
    };
  }, [run]);

  function setVar(name: string, value: string | number | boolean) {
    setVars((v) => ({ ...v, [name]: value }));
    setFiles((prev) => {
      const cur = fileText(prev, main);
      const next = applyVarToSource(cur, name, value);
      if (next === cur) return prev;
      return { ...prev, [main]: encodeText(next) };
    });
  }

  function valueOf(p: Param) {
    return vars[p.name] ?? p.initial;
  }

  function exportStl() {
    if (!stl) return;
    const blob = new Blob([stl], { type: "model/stl" });
    const a = document.createElement("a");
    a.href = URL.createObjectURL(blob);
    a.download = `${title.replace(/\.scad$/i, "") || "model"}.stl`;
    a.click();
    URL.revokeObjectURL(a.href);
  }

  function resetToDefault() {
    skipUrlSync.current = true;
    window.clearTimeout(urlDebounce.current);
    const model =
      pickCatalogFile(scadCatalog, main) ?? {
        name: main,
        source: main === boot.project.main ? fileText(boot.project.files, main) : mainSource,
      };
    const fresh = defaultProject(model.source, model.name);
    setFiles(fresh.files);
    setMain(fresh.main);
    setOpenPath(fresh.main);
    setVars({});
    setDiags([]);
    setErr(false);
    setStatus("Model defaults restored");
    clearShareUrl();
    rememberModel(model.name);
    syncProjectUrl(fresh.files, fresh.main, {}, scadCatalog);
  }

  function loadCatalogModel(name: string) {
    const hit = pickCatalogFile(scadCatalog, name);
    if (!hit) return;
    skipUrlSync.current = true;
    window.clearTimeout(urlDebounce.current);
    const fresh = defaultProject(hit.source, hit.name);
    setStl(null);
    setParts(null);
    setFiles(fresh.files);
    setMain(fresh.main);
    setOpenPath(fresh.main);
    setVars({});
    setDiags([]);
    setErr(false);
    setStatus(hit.name);
    rememberModel(hit.name);
    // Persist immediately: a reload must not race the debounced editor sync.
    syncProjectUrl(fresh.files, fresh.main, {}, scadCatalog);
  }

  async function copyShareLink() {
    const url = shareUrl(files, main, vars);
    if (url.length > MAX_SHARE_URL) {
      setErr(true);
      setStatus("Project is too large for a URL");
      return;
    }
    history.replaceState(null, "", url);
    try {
      await navigator.clipboard.writeText(url);
      setErr(false);
      setStatus("Link copied");
    } catch {
      setErr(false);
      setStatus("Link updated in the address bar");
    }
  }

  return (
    <div className="app">
      <header className="toolbar">
        <h1 title={main}>{title}</h1>
        {catalogNames().length ? (
          <select
            value={main in scadCatalog ? main : ""}
            onChange={(e) => loadCatalogModel(e.target.value)}
            title="File from openscad/"
          >
            {main in scadCatalog ? null : <option value="">custom file</option>}
            {catalogNames().map((name) => (
              <option key={name} value={name}>
                {name}
              </option>
            ))}
          </select>
        ) : null}
        {paths.length > 1 ? (
          <select
            value={openPath}
            onChange={(e) => setOpenPath(e.target.value)}
            title="File in the editor"
          >
            {paths.map((p) => (
              <option key={p} value={p}>
                {p === main ? `${p} (main)` : p}
              </option>
            ))}
          </select>
        ) : null}
        <button className="primary" disabled={busy} onClick={() => run(true, true)}>
          Preview
        </button>
        <button disabled={busy} onClick={() => run(false, true)}>
          Render
        </button>
        <button disabled={!stl} onClick={exportStl}>
          STL
        </button>
        <button disabled={busy} onClick={copyShareLink}>
          Link
        </button>
        <button disabled={busy} onClick={resetToDefault} title="Restore defaults for the selected model">
          Reset
        </button>
        <button
          type="button"
          onClick={() => setTheme((t) => (t === "light" ? "dark" : "light"))}
          title={theme === "light" ? "Switch to dark theme" : "Switch to light theme"}
        >
          {theme === "light" ? "Dark" : "Light"}
        </button>
        <span className={`status ${err ? "err" : "ok"}`}>{status}</span>
      </header>
      <div
        ref={workRef}
        className={`work${resizing ? " resizing" : ""}`}
        style={{ "--editor-share": `${editorRatio}fr`, "--viewer-share": `${1 - editorRatio}fr` } as CSSProperties}
      >
        <div className="editor" id="code-editor-pane">
          <div className="editor-pane">
            <Editor
              language="cpp"
              theme={theme === "light" ? "light" : "vs-dark"}
              value={source}
              onMount={(ed, monaco) => {
                editorRef.current = ed;
                monacoRef.current = monaco;
              }}
              onChange={(v) => {
                const edited = v ?? "";
                setFiles((prev) => ({ ...prev, [openPath]: encodeText(edited) }));
                // Controls already write their values into the source. Keep
                // command-line overrides in sync when the source is edited too.
                if (openPath === main) {
                  const values = new Map(parseCustomizer(edited).map((p) => [p.name, p.initial]));
                  setVars((prev) => Object.fromEntries(
                    Object.keys(prev)
                      .filter((name) => values.has(name))
                      .map((name) => [name, values.get(name)!])
                  ));
                }
              }}
              options={{
                minimap: { enabled: false },
                fontSize: 13,
                wordWrap: "on",
                automaticLayout: true,
                glyphMargin: true,
                renderValidationDecorations: "on",
              }}
            />
          </div>
          {diags[0] ? (
            <button
              type="button"
              className="diag-bar"
              onClick={() => {
                const d = diags[0];
                if (!d) return;
                if (files[d.file] && !sameFile(d.file, openPath)) setOpenPath(d.file);
                const ed = editorRef.current;
                const count = ed?.getModel()?.getLineCount() ?? d.line;
                const line = Math.min(Math.max(1, d.line), count);
                ed?.revealLineInCenter(line);
                ed?.setPosition({ lineNumber: line, column: 1 });
              }}
            >
              {formatDiag(diags[0])}
            </button>
          ) : null}
        </div>
        <div
          className="editor-resizer"
          role="separator"
          aria-label="Resize code editor"
          aria-orientation="vertical"
          aria-controls="code-editor-pane"
          aria-valuenow={Math.round(editorRatio * 100)}
          tabIndex={0}
          title="Drag to resize code editor"
          onPointerDown={(e) => {
            if (e.button !== 0) return;
            e.preventDefault();
            dragOffset.current = e.clientX - e.currentTarget.getBoundingClientRect().left;
            e.currentTarget.setPointerCapture(e.pointerId);
            setResizing(true);
          }}
          onPointerMove={(e) => {
            if (!e.currentTarget.hasPointerCapture(e.pointerId)) return;
            resizeEditor(e.clientX - (workRef.current?.getBoundingClientRect().left ?? 0) - dragOffset.current);
          }}
          onPointerUp={(e) => {
            if (e.currentTarget.hasPointerCapture(e.pointerId)) e.currentTarget.releasePointerCapture(e.pointerId);
            setResizing(false);
          }}
          onPointerCancel={() => setResizing(false)}
          onLostPointerCapture={() => setResizing(false)}
          onKeyDown={(e) => {
            if (e.key !== "ArrowLeft" && e.key !== "ArrowRight") return;
            e.preventDefault();
            const width = workRef.current?.firstElementChild?.getBoundingClientRect().width ?? 280;
            resizeEditor(width + (e.key === "ArrowRight" ? 20 : -20));
          }}
        />
        <div className="stage">
          <Viewer
            stl={stl}
            parts={parts}
            part={part}
            vars={previewVars}
            theme={theme}
            downloadName={`${title}-${part}`}
          />
        </div>
        <aside className="params">
          {Object.entries(grouped).map(([group, list]) => (
            <section key={group}>
              <h2>{group}</h2>
              {list.map((p) => (
                <ParamField
                  key={p.name}
                  param={boundParam(p, vars, params)}
                  value={valueOf(p)}
                  onChange={setVar}
                />
              ))}
              {group === "Windows" && sheet ? <SheetCutInfo sheet={sheet} /> : null}
            </section>
          ))}
          {sheet && !grouped.Windows ? (
            <section>
              <h2>Sheets</h2>
              <SheetCutInfo sheet={sheet} />
            </section>
          ) : null}
        </aside>
      </div>
    </div>
  );
}

function boundParam(param: Param, vars: Vars, params: Param[]): Param {
  if (param.name === "thickness" && params.some((p) => p.name === "lid_half_thickness")) {
    return { ...param, min: 0.1, step: 0.1, recommendedMin: 2.4 };
  }
  if (param.name !== "fillet_radius" && param.name !== "divider_height") return param;
  const n = (name: string, fallback: number) => {
    const p = params.find((x) => x.name === name);
    const v = vars[name] ?? p?.initial ?? fallback;
    return typeof v === "number" && Number.isFinite(v) ? v : fallback;
  };
  const wall = Math.min(
    n("thickness", 3),
    n("length", 80) / 2 - 0.8,
    n("width", 50) / 2 - 0.8,
    n("height", 40) - 1
  );
  if (param.name === "divider_height") {
    const height = n("height", 40);
    const half = n("lid_half_thickness", 0);
    const lidH = Math.min(half > 0 ? half : wall / 2, (height - wall - 1) / 2);
    const max = Math.max(0, height - 2 * lidH - wall - Math.max(0.2, n("divider_lid_gap", 1)));
    return { ...param, min: 0, max, step: 0.1 };
  }
  return { ...param, min: 0, max: Math.max(0, wall / 2), step: 0.1 };
}

function SheetCutInfo({
  sheet,
}: {
  sheet: { count: number; length: number; width: number; thickness: number };
}) {
  return (
    <div className="sheet-cut">
      <div className="sheet-cut-count">{sheet.count} window{sheet.count === 1 ? "" : "s"}</div>
      <div className="sheet-cut-size">
        {formatMm(sheet.length)} × {formatMm(sheet.width)} × {formatMm(sheet.thickness)} mm
      </div>
      <div className="sheet-cut-hint">length × width × thickness, into the window pocket</div>
    </div>
  );
}

function clampNumber(n: number, param: Param) {
  let x = n;
  if (param.min != null) x = Math.max(param.min, x);
  if (param.max != null) x = Math.min(param.max, x);
  return x;
}

function parseNumberDraft(raw: string) {
  const t = raw.trim().replace(",", ".");
  if (t === "" || t === "-" || t === "." || t === "-.") return null;
  const n = Number(t);
  return Number.isFinite(n) ? n : null;
}

function NumberParamField({
  param,
  value,
  onChange,
}: {
  param: Param;
  value: string | number | boolean;
  onChange: (name: string, value: string | number | boolean) => void;
}) {
  const [draft, setDraft] = useState<string | null>(null);
  const n = Number(value);
  const shown = Number.isFinite(n) ? n : 0;
  const clamped =
    param.min != null && param.max != null ? clampNumber(shown, param) : shown;
  const text = draft ?? (Number.isFinite(n) ? String(n) : "");
  const entered = parseNumberDraft(text);
  const warning = entered != null && param.recommendedMin != null && entered < param.recommendedMin
    ? `Below the recommended minimum: wall thickness for 3D printing should be at least ${param.recommendedMin} mm.`
    : undefined;

  function commit(raw: string) {
    const parsed = parseNumberDraft(raw);
    const next = parsed == null ? clamped : clampNumber(parsed, param);
    onChange(param.name, next);
    setDraft(null);
  }

  return (
    <div className="row">
      {param.min != null && param.max != null ? (
        <input
          type="range"
          min={param.min}
          max={param.max}
          step={param.step ?? 1}
          value={clamped}
          onChange={(e) => {
            setDraft(null);
            onChange(param.name, Number(e.target.value));
          }}
        />
      ) : null}
      <input
        className={`num${warning ? " warning" : ""}`}
        title={warning}
        aria-label={param.caption || param.name}
        aria-description={warning}
        type="text"
        inputMode="decimal"
        value={text}
        onFocus={() => setDraft(Number.isFinite(n) ? String(n) : "")}
        onChange={(e) => {
          const raw = e.target.value;
          setDraft(raw);
          const parsed = parseNumberDraft(raw);
          if (
            parsed != null &&
            (param.min == null || parsed >= param.min) &&
            (param.max == null || parsed <= param.max)
          ) {
            onChange(param.name, parsed);
          }
        }}
        onBlur={(e) => commit(e.target.value)}
        onKeyDown={(e) => {
          if (e.key === "Enter") (e.target as HTMLInputElement).blur();
        }}
      />
    </div>
  );
}

function ParamField({
  param,
  value,
  onChange,
}: {
  param: Param;
  value: string | number | boolean;
  onChange: (name: string, value: string | number | boolean) => void;
}) {
  const label = param.caption || param.name;
  if (param.type === "boolean") {
    return (
      <div className="field">
        <label>
          <input
            type="checkbox"
            checked={Boolean(value)}
            onChange={(e) => onChange(param.name, e.target.checked)}
          />{" "}
          {label}
          {param.caption ? <span className="name">{param.name}</span> : null}
        </label>
      </div>
    );
  }
  if (param.options) {
    return (
      <div className="field">
        <label>
          {label}
          {param.caption ? <span className="name">{param.name}</span> : null}
        </label>
        <select
          value={String(value)}
          onChange={(e) => {
            const opt = param.options!.find((o) => String(o.value) === e.target.value);
            onChange(param.name, opt ? opt.value : e.target.value);
          }}
        >
          {param.options.map((o) => (
            <option key={String(o.value)} value={String(o.value)}>
              {o.name}
            </option>
          ))}
        </select>
      </div>
    );
  }
  if (param.type === "number") {
    return (
      <div className="field">
        <label>
          {label}
          {param.caption ? <span className="name">{param.name}</span> : null}
        </label>
        <NumberParamField param={param} value={value} onChange={onChange} />
      </div>
    );
  }
  const hex = String(value).trim();
  if (/^#[0-9a-fA-F]{6}$/.test(hex)) {
    return (
      <div className="field">
        <label>
          {label}
          {param.caption ? <span className="name">{param.name}</span> : null}
        </label>
        <div className="row">
          <input
            type="color"
            value={hex}
            onChange={(e) => onChange(param.name, e.target.value)}
          />
          <input type="text" value={hex} onChange={(e) => onChange(param.name, e.target.value)} />
        </div>
      </div>
    );
  }
  return (
    <div className="field">
      <label>
        {label}
        {param.caption ? <span className="name">{param.name}</span> : null}
      </label>
      <input type="text" value={String(value)} onChange={(e) => onChange(param.name, e.target.value)} />
    </div>
  );
}

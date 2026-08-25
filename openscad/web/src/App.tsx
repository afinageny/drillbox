import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import Editor, { type Monaco } from "@monaco-editor/react";
import { name as initialName, source as initialScad } from "virtual:scad";
import { applyVarsToSource, applyVarToSource, parseCustomizer, type Param, type Vars } from "./customizer";
import { formatDiag, parseOpenScadDiagnostics, sameFile, type Diag } from "./diagnostics";
import { Viewer } from "./Viewer";
import {
  defaultProject,
  encodeText,
  fileText,
  isSingleScad,
  loadProjectFromUrl,
  MAX_SHARE_URL,
  readVarsFromParams,
  replaceShareUrl,
  scadPaths,
  shareUrl,
} from "./project";

type Job = {
  id: number;
  preview: boolean;
};

function readBoot() {
  const fromUrl = loadProjectFromUrl();
  const vars =
    fromUrl?.vars && Object.keys(fromUrl.vars).length ? fromUrl.vars : readVarsFromParams();
  let project = fromUrl;
  let error: string | null = null;
  if (!fromUrl) {
    project = defaultProject(initialScad, initialName);
  } else if (fromUrl.error || !Object.keys(fromUrl.files).length) {
    project = defaultProject(initialScad, initialName);
    error = fromUrl.error ?? "Не удалось прочитать параметр URL";
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
  const [main] = useState(boot.project.main);
  const [openPath, setOpenPath] = useState(boot.project.main);
  const [vars, setVars] = useState<Vars>(boot.project.vars ?? {});
  const [stl, setStl] = useState<ArrayBuffer | null>(null);
  const [parts, setParts] = useState<ArrayBuffer[] | null>(null);
  const [status, setStatus] = useState(boot.error ?? "Загрузка WASM…");
  const [err, setErr] = useState(Boolean(boot.error));
  const [busy, setBusy] = useState(false);
  const [diags, setDiags] = useState<Diag[]>([]);
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
  const grouped = useMemo(() => {
    const g: Record<string, Param[]> = {};
    for (const p of params) (g[p.group] ??= []).push(p);
    return g;
  }, [params]);
  const title = (main.split("/").pop() ?? "OpenSCAD").replace(/\.scad$/i, "");
  const part = String(vars.part ?? params.find((p) => p.name === "part")?.initial ?? "assembly");

  const run = useCallback(
    (preview: boolean, now = false) => {
      window.clearTimeout(debounce.current);
      const start = () => {
        job.current.worker?.terminate();
        const id = job.current.id + 1;
        job.current = { id, preview };
        setBusy(true);
        setErr(false);
        setStatus(preview ? "Превью…" : "Рендер…");
        const worker = new Worker(`${import.meta.env.BASE_URL}openscad-worker.js?v=3`, {
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
            setStatus(first ? formatDiag(first) : ev.data.error || "Ошибка OpenSCAD");
            return;
          }
          setStl(ev.data.stl);
          setParts(ev.data.parts ?? null);
          setErr(false);
          setDiags([]);
          setStatus(preview ? "Превью готово" : "Рендер готов");
        };
        worker.onerror = (e) => {
          if (job.current.id !== id) return;
          setBusy(false);
          setErr(true);
          setStatus(e.message || "Ошибка worker");
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
    if (!monaco || !model) return;
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
      replaceShareUrl(files, main, vars);
    }, 350);
    return () => window.clearTimeout(urlDebounce.current);
  }, [files, main, vars]);

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

  async function copyShareLink() {
    const url = shareUrl(files, main, vars);
    if (url.length > MAX_SHARE_URL) {
      setErr(true);
      setStatus("Проект слишком большой для URL");
      return;
    }
    history.replaceState(null, "", url);
    try {
      await navigator.clipboard.writeText(url);
      setErr(false);
      setStatus("Ссылка скопирована");
    } catch {
      setErr(false);
      setStatus("Ссылка обновлена в адресной строке");
    }
  }

  return (
    <div className="app">
      <header className="toolbar">
        <h1 title={main}>{title}</h1>
        {paths.length > 1 ? (
          <select
            value={openPath}
            onChange={(e) => setOpenPath(e.target.value)}
            title="Файл в редакторе"
          >
            {paths.map((p) => (
              <option key={p} value={p}>
                {p === main ? `${p} (main)` : p}
              </option>
            ))}
          </select>
        ) : null}
        <button className="primary" disabled={busy} onClick={() => run(true, true)}>
          Превью
        </button>
        <button disabled={busy} onClick={() => run(false, true)}>
          Рендер
        </button>
        <button disabled={!stl} onClick={exportStl}>
          STL
        </button>
        <button disabled={busy} onClick={copyShareLink}>
          Ссылка
        </button>
        <span className={`status ${err ? "err" : "ok"}`}>{status}</span>
      </header>
      <div className="work">
        <div className="editor">
          <div className="editor-pane">
            <Editor
              language="cpp"
              theme="vs-dark"
              value={source}
              onMount={(ed, monaco) => {
                editorRef.current = ed;
                monacoRef.current = monaco;
              }}
              onChange={(v) => {
                setFiles((prev) => ({ ...prev, [openPath]: encodeText(v ?? "") }));
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
        <div className="stage">
          <Viewer stl={stl} parts={parts} part={part} />
        </div>
        <aside className="params">
          {Object.entries(grouped).map(([group, list]) => (
            <section key={group}>
              <h2>{group}</h2>
              {list.map((p) => (
                <ParamField key={p.name} param={p} value={valueOf(p)} onChange={setVar} />
              ))}
            </section>
          ))}
        </aside>
      </div>
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
    const n = Number(value);
    return (
      <div className="field">
        <label>
          {label}
          {param.caption ? <span className="name">{param.name}</span> : null}
        </label>
        <div className="row">
          {param.min != null && param.max != null ? (
            <input
              type="range"
              min={param.min}
              max={param.max}
              step={param.step ?? 1}
              value={n}
              onChange={(e) => onChange(param.name, Number(e.target.value))}
            />
          ) : null}
          <input
            type="number"
            min={param.min}
            max={param.max}
            step={param.step ?? 1}
            value={n}
            onChange={(e) => onChange(param.name, Number(e.target.value))}
          />
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

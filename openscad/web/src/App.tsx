import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import Editor from "@monaco-editor/react";
import initialScad from "../../drillbox.scad?raw";
import { parseCustomizer, type Param, type Vars } from "./customizer";
import { Viewer } from "./Viewer";

type Job = {
  id: number;
  preview: boolean;
};

export function App() {
  const [source, setSource] = useState(initialScad);
  const [vars, setVars] = useState<Vars>({});
  const [stl, setStl] = useState<ArrayBuffer | null>(null);
  const [status, setStatus] = useState("Загрузка WASM…");
  const [err, setErr] = useState(false);
  const [busy, setBusy] = useState(false);
  const job = useRef<Job & { worker?: Worker }>({ id: 0, preview: true });
  const debounce = useRef<number>(0);

  const params = useMemo(() => parseCustomizer(source), [source]);
  const grouped = useMemo(() => {
    const g: Record<string, Param[]> = {};
    for (const p of params) (g[p.group] ??= []).push(p);
    return g;
  }, [params]);

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
        const worker = new Worker(`${import.meta.env.BASE_URL}openscad-worker.js`, {
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
            setStatus(ev.data.error || "Ошибка OpenSCAD");
            return;
          }
          setStl(ev.data.stl);
          setErr(false);
          setStatus(preview ? "Превью готово" : "Рендер готов");
        };
        worker.onerror = (e) => {
          if (job.current.id !== id) return;
          setBusy(false);
          setErr(true);
          setStatus(e.message || "Ошибка worker");
        };
        worker.postMessage({ id, source, vars, preview });
      };
      if (now) start();
      else debounce.current = window.setTimeout(start, 700);
    },
    [source, vars]
  );

  useEffect(() => {
    run(true, false);
    return () => {
      window.clearTimeout(debounce.current);
      job.current.worker?.terminate();
    };
  }, [run]);

  function setVar(name: string, value: string | number | boolean) {
    setVars((v) => ({ ...v, [name]: value }));
  }

  function valueOf(p: Param) {
    return vars[p.name] ?? p.initial;
  }

  function exportStl() {
    if (!stl) return;
    const blob = new Blob([stl], { type: "model/stl" });
    const a = document.createElement("a");
    a.href = URL.createObjectURL(blob);
    a.download = `${String(vars.part ?? "drillbox")}.stl`;
    a.click();
    URL.revokeObjectURL(a.href);
  }

  return (
    <div className="app">
      <header className="toolbar">
        <h1>Drillbox</h1>
        <button className="primary" disabled={busy} onClick={() => run(true, true)}>
          Превью
        </button>
        <button disabled={busy} onClick={() => run(false, true)}>
          Рендер
        </button>
        <button disabled={!stl} onClick={exportStl}>
          STL
        </button>
        <span className={`status ${err ? "err" : "ok"}`}>{status}</span>
      </header>
      <div className="work">
        <div className="editor">
          <Editor
            language="cpp"
            theme="vs-dark"
            value={source}
            onChange={(v) => setSource(v ?? "")}
            options={{
              minimap: { enabled: false },
              fontSize: 13,
              wordWrap: "on",
              automaticLayout: true,
            }}
          />
        </div>
        <div className="stage">
          <Viewer stl={stl} />
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

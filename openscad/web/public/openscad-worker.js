import OpenSCAD from "./wasm/openscad.js";

function formatDefine(value) {
  if (typeof value === "string") return `"${value.replace(/"/g, '\\"')}"`;
  return String(value);
}

function mkdirp(FS, dir) {
  const parts = String(dir || "")
    .split("/")
    .filter(Boolean);
  let acc = "";
  for (const part of parts) {
    acc += `/${part}`;
    try {
      FS.mkdir(acc);
    } catch {
      /* exists */
    }
  }
}

function writeFiles(FS, files) {
  mkdirp(FS, "/work");
  for (const [rel, data] of Object.entries(files || {})) {
    const clean = String(rel).replace(/\\/g, "/").replace(/^\/+/, "");
    if (!clean || clean.split("/").includes("..")) continue;
    const full = `/work/${clean}`;
    const slash = full.lastIndexOf("/");
    if (slash > 0) mkdirp(FS, full.slice(0, slash));
    if (typeof data === "string" || full.toLowerCase().endsWith(".scad")) {
      const text =
        typeof data === "string"
          ? data
          : new TextDecoder().decode(data instanceof Uint8Array ? data : new Uint8Array(data));
      FS.writeFile(full, text);
    } else {
      FS.writeFile(full, data instanceof Uint8Array ? data : new Uint8Array(data));
    }
  }
}

function usefulLog(logs) {
  return logs.filter((l) => l && !/localization|application path/i.test(String(l))).join("\n");
}

self.onmessage = async (event) => {
  const { id, source, files, main, vars, preview } = event.data;
  const logs = [];
  try {
    const instance = await OpenSCAD({
      noInitialRun: true,
      print: (t) => logs.push(String(t)),
      printErr: (t) => logs.push(String(t)),
    });

    const hasFiles = files && Object.keys(files).length;
    const mainRel = String(main || "input.scad").replace(/\\/g, "/").replace(/^\/+/, "");
    const mainPath = hasFiles ? `/work/${mainRel}` : "/input.scad";

    if (hasFiles) writeFiles(instance.FS, files);
    else instance.FS.writeFile("/input.scad", source || "");

    const raw = instance.FS.readFile(mainPath, { encoding: "utf8" });
    instance.FS.writeFile(
      mainPath,
      `${preview ? "$preview=true;\n" : "$preview=false;\n"}${raw}`
    );

    const args = [
      mainPath,
      "-o",
      "/out.stl",
      "--export-format=binstl",
      "--backend=manifold",
      ...Object.entries(vars || {}).flatMap(([k, v]) => [`-D${k}=${formatDefine(v)}`]),
    ];
    const exitCode = instance.callMain(args);
    if (exitCode) {
      throw new Error(usefulLog(logs) || `OpenSCAD exit ${exitCode}`);
    }
    const stl = instance.FS.readFile("/out.stl");
    const copy = stl.buffer.slice(stl.byteOffset, stl.byteOffset + stl.byteLength);
    self.postMessage({ id, ok: true, stl: copy, log: logs.join("\n") }, [copy]);
  } catch (err) {
    self.postMessage({
      id,
      ok: false,
      error: String(err && err.message ? err.message : err),
      log: logs.join("\n"),
    });
  }
};

import OpenSCAD from "./wasm/openscad.js";

function formatDefine(value) {
  if (typeof value === "string") return `"${value.replace(/"/g, '\\"')}"`;
  return String(value);
}

self.onmessage = async (event) => {
  const { id, source, vars, preview } = event.data;
  const logs = [];
  try {
    const instance = await OpenSCAD({
      noInitialRun: true,
      print: (t) => logs.push(String(t)),
      printErr: (t) => logs.push(String(t)),
    });

    instance.FS.writeFile(
      "/input.scad",
      `${preview ? "$preview=true;\n" : "$preview=false;\n"}${source}`
    );

    const args = [
      "/input.scad",
      "-o",
      "/out.stl",
      "--export-format=binstl",
      "--backend=manifold",
      ...Object.entries(vars || {}).flatMap(([k, v]) => [`-D${k}=${formatDefine(v)}`]),
    ];
    const exitCode = instance.callMain(args);
    if (exitCode) {
      throw new Error(logs.slice(-40).join("\n") || `OpenSCAD exit ${exitCode}`);
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

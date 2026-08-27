import { spawn } from "node:child_process";
import path from "node:path";
import { fileURLToPath } from "node:url";

const argv = process.argv.slice(2);
const rest = [];
let scad;

for (let i = 0; i < argv.length; i++) {
  const arg = argv[i];
  if (arg === "--scad" || arg === "--scad-file" || arg === "--openscad") {
    scad = argv[++i];
    continue;
  }
  const eq = arg.match(/^--(?:scad|scad-file|openscad)=(.*)$/);
  if (eq) {
    scad = eq[1];
    continue;
  }
  if (arg.toLowerCase().endsWith(".scad") && !arg.startsWith("-")) {
    scad = arg;
    continue;
  }
  rest.push(arg);
}

const env = { ...process.env };
if (scad) env.SCAD = scad;

if (scad) console.log(`OpenSCAD ${scad}`);

const viteJs = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "../node_modules/vite/bin/vite.js");
const child = spawn(process.execPath, [viteJs, ...rest], { stdio: "inherit", env, windowsHide: true });
child.on("exit", (code, signal) => {
  if (signal) process.kill(process.pid, signal);
  else process.exit(code ?? 1);
});

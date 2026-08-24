import { execFileSync } from "node:child_process";
import { createWriteStream } from "node:fs";
import { mkdir, readdir, copyFile, stat } from "node:fs/promises";
import { pipeline } from "node:stream/promises";
import { Readable } from "node:stream";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.resolve(__dirname, "..");
const dest = path.join(root, "public", "wasm");
const zipPath = path.join(root, "public", "openscad-wasm.zip");
const URL =
  "https://files.openscad.org/playground/OpenSCAD-2025.03.25.wasm24456-WebAssembly-web.zip";

async function exists(p) {
  try {
    await stat(p);
    return true;
  } catch {
    return false;
  }
}

async function findFile(dir, name) {
  const entries = await readdir(dir, { withFileTypes: true });
  for (const e of entries) {
    const full = path.join(dir, e.name);
    if (e.isDirectory()) {
      const hit = await findFile(full, name);
      if (hit) return hit;
    } else if (e.name === name) {
      return full;
    }
  }
  return null;
}

if ((await exists(path.join(dest, "openscad.js"))) && (await exists(path.join(dest, "openscad.wasm")))) {
  console.log("OpenSCAD WASM already present.");
  process.exit(0);
}

await mkdir(dest, { recursive: true });
console.log("Downloading OpenSCAD WASM…");
const res = await fetch(URL);
if (!res.ok || !res.body) {
  throw new Error(`Download failed: ${res.status} ${res.statusText}`);
}
await pipeline(Readable.fromWeb(res.body), createWriteStream(zipPath));

console.log("Unpacking…");
execFileSync("tar", ["-xf", zipPath, "-C", dest], { stdio: "inherit" });

const js = await findFile(dest, "openscad.js");
const wasm = await findFile(dest, "openscad.wasm");
if (!js || !wasm) {
  throw new Error("openscad.js / openscad.wasm not found in the zip");
}
if (path.dirname(js) !== dest) {
  await copyFile(js, path.join(dest, "openscad.js"));
}
if (path.dirname(wasm) !== dest) {
  await copyFile(wasm, path.join(dest, "openscad.wasm"));
}
console.log("WASM ready in public/wasm/");

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

function copyStl(stl) {
  return stl.buffer.slice(stl.byteOffset, stl.byteOffset + stl.byteLength);
}

function mergeBinStl(buffers) {
  const chunks = [];
  let n = 0;
  for (const buf of buffers) {
    const u8 = buf instanceof Uint8Array ? buf : new Uint8Array(buf);
    if (u8.byteLength < 84) continue;
    const count = new DataView(u8.buffer, u8.byteOffset, u8.byteLength).getUint32(80, true);
    n += count;
    chunks.push(u8.subarray(84, 84 + count * 50));
  }
  const out = new Uint8Array(84 + n * 50);
  new DataView(out.buffer).setUint32(80, n, true);
  let o = 84;
  for (const c of chunks) {
    out.set(c, o);
    o += c.length;
  }
  return out.buffer;
}

async function compileStl(files, main, vars, preview, logs, allowEmpty = false) {
  const logStart = logs.length;
  const instance = await OpenSCAD({
    noInitialRun: true,
    print: (t) => logs.push(String(t)),
    printErr: (t) => logs.push(String(t)),
  });

  const hasFiles = files && Object.keys(files).length;
  const mainRel = String(main || "input.scad").replace(/\\/g, "/").replace(/^\/+/, "");
  const mainPath = hasFiles ? `/work/${mainRel}` : "/input.scad";

  if (hasFiles) writeFiles(instance.FS, files);
  else instance.FS.writeFile("/input.scad", "");

  const raw = instance.FS.readFile(mainPath, { encoding: "utf8" });
  instance.FS.writeFile(mainPath, `${preview ? "$preview=true;\n" : "$preview=false;\n"}${raw}`);

  const args = [
    mainPath,
    "-o",
    "/out.stl",
    "--export-format=binstl",
    "--backend=manifold",
    ...Object.entries(vars || {}).flatMap(([k, v]) => [`-D${k}=${formatDefine(v)}`]),
  ];
  const exitCode = instance.callMain(args);
  const callLogs = logs.slice(logStart);
  // An optional assembly group may be absent in older or customized SCAD files.
  // Keep its position in the parts array so subsequent colors remain aligned.
  if (allowEmpty && callLogs.some((line) => /Current top level object is empty\./.test(line)) &&
      !callLogs.some((line) => /\bERROR:/.test(line))) {
    return new ArrayBuffer(84);
  }
  if (exitCode) {
    throw new Error(usefulLog(logs) || `OpenSCAD exit ${exitCode}`);
  }
  return copyStl(instance.FS.readFile("/out.stl"));
}

self.onmessage = async (event) => {
  const { id, source, files, main, vars, preview } = event.data;
  const logs = [];
  try {
    const hasFiles = files && Object.keys(files).length;
    const inputFiles = hasFiles ? files : { "input.scad": source || "" };
    const inputMain = hasFiles ? main : "input.scad";
    const part = vars && vars.part != null ? String(vars.part) : "print";

    // Only models declaring the sandwich-lid selectors support this split.
    // Other SCAD models must receive their original part selection unchanged.
    const mainSource = inputFiles[inputMain];
    const sandwichSelectors = [
      "box", "lidSandwichTopLayout", "lidSandwichBottomLayout",
      "lidSandwichTopPlaced", "lidSandwichBottomPlaced",
    ];
    const hasSandwichParts = typeof mainSource === "string" &&
      sandwichSelectors.every((name) => mainSource.includes(`"${name}"`));
    if (hasSandwichParts && (part === "assembly" || part === "print")) {
      const names =
        part === "print"
          ? ["box", "lidSandwichTopLayout", "lidSandwichBottomLayout"]
          : ["box", "lidSandwichTopPlaced", "lidSandwichBottomPlaced"];
      const parts = [];
      for (const name of names) {
        parts.push(
          await compileStl(inputFiles, inputMain, { ...vars, part: name }, preview, logs)
        );
      }
      const stl = mergeBinStl(parts);
      self.postMessage({ id, ok: true, stl, parts, log: logs.join("\n") }, [stl, ...parts]);
      return;
    }

    const normalizedMain = inputMain.replace(/\\/g, "/");
    const hasTileCutter = /(?:^|\/)tile-cutter\.scad$/i.test(normalizedMain);
    if (hasTileCutter && part === "assembly") {
      const names = [
        "guide", "trolley_placed", "bearings", "bolts", "nuts", "washers", "cutter_arm_placed",
        "cutter_wheel_placed", "cutter_axle_placed", "handle_placed", "handle_stud_placed"
      ];
      const parts = [];
      for (const name of names) {
        parts.push(
          await compileStl(inputFiles, inputMain, { ...vars, part: name }, preview, logs,
            ["nuts", "washers", "handle_placed", "handle_stud_placed"].includes(name))
        );
      }
      const stl = mergeBinStl(parts);
      self.postMessage({ id, ok: true, stl, parts, log: logs.join("\n") }, [stl, ...parts]);
      return;
    }

    const hasTileCarriage = /(?:^|\/)(?:tile_carriage|tile-carriage-next)\.scad$/i.test(normalizedMain);
    const isNextTileCarriage = /(?:^|\/)tile-carriage-next\.scad$/i.test(normalizedMain);
    if (hasTileCarriage && (part === "assembly" || (isNextTileCarriage && part === "print"))) {
      const names = part === "print"
        ? ["print_body", "print_axles", "print_washers", "print_side_fasteners", "print_magnet_screws"]
        : ["guide", "carriage", "front_wheels", "cutter", "washers", "axles"];
      if (isNextTileCarriage && part === "assembly") {
        names.push("side_bearings", "side_fasteners", "magnets", "magnet_screws");
      }
      const parts = [];
      for (const name of names) {
        parts.push(
          await compileStl(inputFiles, inputMain, { ...vars, part: name }, preview, logs,
            name === "magnets" || name === "magnet_screws" || name === "print_magnet_screws")
        );
      }
      const stl = mergeBinStl(parts);
      self.postMessage({ id, ok: true, stl, parts, log: logs.join("\n") }, [stl, ...parts]);
      return;
    }

    const stl = await compileStl(inputFiles, inputMain, vars, preview, logs);
    self.postMessage({ id, ok: true, stl, log: logs.join("\n") }, [stl]);
  } catch (err) {
    self.postMessage({
      id,
      ok: false,
      error: String(err && err.message ? err.message : err),
      log: logs.join("\n"),
    });
  }
};

import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import react from "@vitejs/plugin-react";
import { defineConfig, searchForWorkspaceRoot, type Plugin } from "vite";

const webRoot = path.dirname(fileURLToPath(import.meta.url));
const DEFAULT_SCAD = path.resolve(webRoot, "../drillbox/drillbox.scad");
const repoName = process.env.GITHUB_REPOSITORY?.split("/")[1];
const pagesBase = process.env.GITHUB_PAGES === "true" && repoName ? `/${repoName}/` : "/";

function resolveScadFile(): string {
  const spec = process.env.SCAD?.trim();
  const abs = spec
    ? path.isAbsolute(spec)
      ? spec
      : path.resolve(process.cwd(), spec)
    : DEFAULT_SCAD;
  if (!fs.existsSync(abs) || !fs.statSync(abs).isFile()) {
    throw new Error(
      `OpenSCAD file not found: ${abs}\nPass --scad <file> or set SCAD=`
    );
  }
  return path.normalize(abs);
}

function scadEntryPlugin(file: string): Plugin {
  const virtualId = "virtual:scad";
  const resolvedId = `\0${virtualId}`;
  const name = path.basename(file);
  return {
    name: "scad-entry",
    configResolved(config) {
      config.logger.info(`OpenSCAD ${file}`);
    },
    resolveId(id) {
      if (id === virtualId) return resolvedId;
    },
    load(id) {
      if (id !== resolvedId) return;
      this.addWatchFile(file);
      const source = fs.readFileSync(file, "utf8");
      return `export const source = ${JSON.stringify(source)};\nexport const name = ${JSON.stringify(name)};\n`;
    },
    configureServer(server) {
      server.watcher.add(file);
    },
    handleHotUpdate({ file: changed, server }) {
      if (path.resolve(changed) !== path.resolve(file)) return;
      server.ws.send({ type: "full-reload" });
      return [];
    },
  };
}

const scadFile = resolveScadFile();

export default defineConfig({
  base: pagesBase,
  plugins: [react(), scadEntryPlugin(scadFile)],
  server: {
    port: 5173,
    host: "127.0.0.1",
    fs: {
      allow: ["..", searchForWorkspaceRoot(webRoot), path.dirname(scadFile)],
    },
  },
});

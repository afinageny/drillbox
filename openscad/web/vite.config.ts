import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

const pagesBase = process.env.GITHUB_PAGES === "true" ? "/drillbox/" : "/";

export default defineConfig({
  base: pagesBase,
  plugins: [react()],
  server: {
    port: 5173,
    host: "127.0.0.1",
    fs: { allow: [".."] },
  },
});

/// <reference types="vite/client" />

declare module "virtual:scad" {
  export const source: string;
  export const name: string;
}

declare module "*.scad?raw" {
  const src: string;
  export default src;
}

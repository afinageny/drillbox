/// <reference types="vite/client" />

declare module "virtual:scad" {
  export const source: string;
  export const name: string;
}

declare module "virtual:scad-catalog" {
  export const files: Record<string, string>;
  export const defaultName: string;
}

declare module "*.scad?raw" {
  const src: string;
  export default src;
}

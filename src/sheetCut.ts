import type { Param, Vars } from "./customizer";

function num(vars: Vars, params: Param[], name: string, fallback: number) {
  const p = params.find((x) => x.name === name);
  const v = vars[name] ?? p?.initial ?? fallback;
  return typeof v === "number" && Number.isFinite(v) ? v : fallback;
}

const NEEDED = [
  "width",
  "depth",
  "height",
  "thickness",
  "fillet_radius",
  "lid_thickness",
  "dovetail_angle",
  "clearance",
  "window_count_x",
  "window_count_y",
  "frame_width",
  "window_lip",
  "sheet_thickness",
] as const;

export type SheetCut = {
  count: number;
  width: number;
  depth: number;
  thickness: number;
};

export function sheetCutList(vars: Vars, params: Param[]): SheetCut | null {
  if (!NEEDED.every((name) => params.some((p) => p.name === name))) return null;

  const width = num(vars, params, "width", 80);
  const depth = num(vars, params, "depth", 50);
  const height = num(vars, params, "height", 40);
  const thickness = num(vars, params, "thickness", 3);
  const lidThickness = num(vars, params, "lid_thickness", 0);
  const angle = num(vars, params, "dovetail_angle", 20);
  const clearance = num(vars, params, "clearance", 0.1);
  const windowCountX = num(vars, params, "window_count_x", 2);
  const windowCountY = num(vars, params, "window_count_y", 1);
  const frameWidth = num(vars, params, "frame_width", 5);
  const windowLip = num(vars, params, "window_lip", 2);
  const sheetThickness = num(vars, params, "sheet_thickness", 1);

  const filletRadius = num(vars, params, "fillet_radius", 1.5);
  const wall = Math.min(thickness, width / 2 - 0.8, depth / 2 - 0.8, height - 1);
  const filletR = Math.min(
    Math.max(0, filletRadius),
    wall / 2,
    width / 2 - 0.4,
    depth / 2 - 0.4,
    height / 2 - 0.4
  );
  const lidH = Math.min(lidThickness > 0 ? lidThickness : wall / 2, (height - wall - 1) / 2);
  const flare = Math.min(lidH * Math.tan((angle * Math.PI) / 180), wall - 0.8);
  const yTop = depth / 2 - wall;
  const yBot = yTop + flare;
  const lidC = Math.min(clearance, flare / 3, lidH / 4);
  const stopKeep = Math.max(0.8, wall - filletR);
  const lidLen = width - stopKeep - lidC;
  const yt = yTop - lidC;
  const yb = yBot - lidC;
  const nx = Math.max(1, Math.round(windowCountX));
  const ny = Math.max(1, Math.round(windowCountY));
  const frameX0 = frameWidth + wall - lidC;
  const frameX1 = Math.max(frameWidth, frameWidth + wall - stopKeep);
  const winWx = Math.max(1, (lidLen - frameX0 - frameX1 - (nx - 1) * frameWidth) / nx);
  const winWy = Math.max(1, (2 * yt - (ny + 1) * frameWidth) / ny);

  return {
    count: nx * ny,
    width: winWx + 2 * windowLip,
    depth: Math.min(winWy + 2 * windowLip, 2 * yb - 2),
    thickness: sheetThickness,
  };
}

export function formatMm(value: number) {
  const s = value.toFixed(1);
  return s.endsWith(".0") ? s.slice(0, -2) : s;
}

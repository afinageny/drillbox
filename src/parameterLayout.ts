import type { Param } from "./customizer";

const carriageGroups: Record<string, string[]> = {
  "Вид": ["part", "show_guide", "print_gap"],
  "Правило": ["rail_width", "rail_height", "guide_side", "guide_opacity"],
  "Подшипники и резец": [
    "bearing_diameter", "bearing_width", "bearing_bore",
    "cutter_radius", "cutter_width", "cutter_hole_radius", "cutter_bearing_diameter",
  ],
  "Магниты": [
    "enable_magnets", "enable_center_magnet", "magnet_diameter", "magnet_thickness",
    "magnet_hole_diameter", "magnet_countersink_diameter", "magnet_countersink_wall_angle",
  ],
  "Подгонка печати": [
    "rear_u_clearance", "magnet_fit_clearance", "axle_hole_clearance",
    "thread_external_radial_compensation",
  ],
};

export function parameterLayout(params: Param[], main: string, part: string) {
  const basic: Record<string, Param[]> = {};
  const advanced: Record<string, Param[]> = {};
  const isCarriage = /(?:^|\/)tile-carriage-next\.scad$/i.test(main.replace(/\\/g, "/"));
  if (isCarriage) {
    for (const [group, names] of Object.entries(carriageGroups)) {
      const list = names.flatMap((name) => params.filter((p) => p.name === name));
      if (list.length) basic[group] = list;
    }
  }
  const basicNames = new Set(Object.values(basic).flat().map((p) => p.name));
  for (const p of params) {
    if (p.name === "lid_open" && part !== "assembly") continue;
    if (basicNames.has(p.name)) continue;
    const target = isCarriage ? advanced : basic;
    (target[p.group] ??= []).push(p);
  }
  return { basic, advanced };
}

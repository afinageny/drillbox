export type Vars = Record<string, string | number | boolean>;

export type ParamType = "number" | "string" | "boolean";

export type ParamOption = { name: string; value: string | number };

export type Param = {
  name: string;
  caption?: string;
  group: string;
  type: ParamType;
  initial: string | number | boolean;
  options?: ParamOption[];
  min?: number;
  max?: number;
  step?: number;
};

export function parseLiteral(raw: string): { type: ParamType; value: string | number | boolean } {
  const t = raw.trim();
  if (t === "true") return { type: "boolean", value: true };
  if (t === "false") return { type: "boolean", value: false };
  if ((t.startsWith('"') && t.endsWith('"')) || (t.startsWith("'") && t.endsWith("'"))) {
    return { type: "string", value: t.slice(1, -1) };
  }
  const n = Number(t);
  if (!Number.isNaN(n)) return { type: "number", value: n };
  return { type: "string", value: t };
}

function parseHint(hint: string): Partial<Param> {
  const m = hint.match(/\[([^\]]+)\]/);
  if (!m) return {};
  const inner = m[1].trim();
  if (inner.includes(":")) {
    const parts = inner.split(":").map((s) => s.trim());
    const nums = parts.map(Number);
    if (nums.every((n) => !Number.isNaN(n))) {
      if (nums.length === 2) return { min: nums[0], max: nums[1], step: 1 };
      if (nums.length === 3) return { min: nums[0], step: nums[1], max: nums[2] };
    }
  }
  const options = inner.split(",").map((item) => {
    const bit = item.trim();
    const labeled = bit.match(/^(.+?)\s*:\s*(.+)$/);
    if (labeled) {
      const parsed = parseLiteral(labeled[2]);
      return { name: labeled[1].trim(), value: parsed.value as string | number };
    }
    const parsed = parseLiteral(bit.startsWith('"') ? bit : `"${bit}"`);
    return { name: String(parsed.value), value: parsed.value as string | number };
  });
  return { options };
}

/** OpenSCAD Customizer syntax: groups, captions, [min:max] and combo lists. */
export function parseCustomizer(source: string): Param[] {
  const params: Param[] = [];
  let group = "Parameters";
  let hidden = false;
  let caption: string | undefined;
  const lines = source.split(/\r?\n/);

  for (const line of lines) {
    const trimmed = line.trim();
    if (!trimmed) {
      caption = undefined;
      continue;
    }
    const grp = trimmed.match(/^\/\*\s*\[([^\]]+)\]\s*\*\/$/);
    if (grp) {
      group = grp[1].trim();
      hidden = group.toLowerCase() === "hidden";
      caption = undefined;
      continue;
    }
    if (/^(module|function|include|use)\b/.test(trimmed)) break;
    if (trimmed.startsWith("//")) {
      const text = trimmed.replace(/^\/\/\s?/, "").trim();
      if (text && !text.startsWith("[") && !text.startsWith("ISO")) caption = text;
      continue;
    }
    const asg = trimmed.match(/^([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.+?)\s*;(?:\s*\/\/\s*(.*))?$/);
    if (!asg || hidden) {
      caption = undefined;
      continue;
    }
    const name = asg[1];
    if (name.startsWith("$")) continue;
    const parsed = parseLiteral(asg[2]);
    const extra = asg[3] ? parseHint(asg[3]) : {};
    params.push({
      name,
      caption,
      group,
      type: extra.options && typeof extra.options[0]?.value === "string" ? "string" : parsed.type,
      initial: parsed.value,
      ...extra,
    });
    caption = undefined;
  }
  return params;
}

export function formatDefine(value: string | number | boolean): string {
  if (typeof value === "string") return `"${value.replace(/\\/g, "\\\\").replace(/"/g, '\\"')}"`;
  return String(value);
}

export function applyVarToSource(
  source: string,
  name: string,
  value: string | number | boolean
): string {
  const nl = source.includes("\r\n") ? "\r\n" : "\n";
  const lines = source.split(/\r?\n/);
  const literal = formatDefine(value);
  let done = false;
  const next = lines.map((line) => {
    if (done) return line;
    const trimmed = line.trim();
    if (/^(module|function|include|use)\b/.test(trimmed)) {
      done = true;
      return line;
    }
    const m = line.match(/^(\s*)([A-Za-z_][A-Za-z0-9_]*)(\s*=\s*)([^;]+);(.*)$/);
    if (!m || m[2] !== name) return line;
    done = true;
    return `${m[1]}${m[2]}${m[3]}${literal};${m[5]}`;
  });
  return next.join(nl);
}

export function applyVarsToSource(source: string, vars: Vars): string {
  let next = source;
  for (const [name, value] of Object.entries(vars)) {
    next = applyVarToSource(next, name, value);
  }
  return next;
}

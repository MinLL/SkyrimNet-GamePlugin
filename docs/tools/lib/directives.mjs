// Directives: how a docs page embeds facts instead of restating them.
//
//   :papyrus[SkyrimNetApi.RegisterDecorator]       inline: a link to the fact
//   ::papyrus{script="SkyrimNetApi" section="…"}   block: the reference itself
//
// The set is closed. A directive of an unknown kind, or one naming a fact that
// does not exist, is an error: a renamed or removed function fails the docs
// check and names the page, instead of leaving the page wrong.
//
// Fenced code blocks and inline code spans are never read for directives, so
// a page can show the syntax itself.

/** Inline kinds, each `:kind[id]` resolving to the fact `kind:id`. */
export const INLINE_KINDS = [
  "papyrus",
  "setting",
  "ui",
  "decorator",
  "action",
  "model",
  "provider",
  "stt_backend",
  "tts_engine",
];

/** Block kinds and the attributes each takes. */
export const BLOCK_KINDS = {
  papyrus: { required: ["script"], optional: ["section"] },
};

const FENCE = /^\s*(```|~~~)/;
const BLOCK = /^::(\w+)\{(.*)\}\s*$/;
const ATTR = /(\w+)="([^"]*)"/g;
const INLINE = new RegExp(`(^|[^\\w:])(:(${INLINE_KINDS.join("|")})\\[([^\\]\\s]+)\\])`, "g");

/**
 * The anchor a heading gets. Renderers must use this so links built here
 * land: lowercase, runs of anything but letters and digits become one `-`.
 */
export function slug(text) {
  return text
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-|-$/g, "");
}

function parseAttrs(text) {
  const attrs = {};
  for (const m of text.matchAll(ATTR)) attrs[m[1]] = m[2];
  const rest = text.replace(ATTR, "").trim();
  return { attrs, rest };
}

/**
 * Walks a page's lines outside fenced code, calling `onBlock` for a block
 * directive line and `onText` for every other line.
 */
function walk(body, onBlock, onText) {
  let fence = null;
  body.split("\n").forEach((line, i) => {
    const f = FENCE.exec(line);
    if (fence) {
      if (f && f[1] === fence) fence = null;
      onText(line, i, true);
      return;
    }
    if (f) {
      fence = f[1];
      onText(line, i, true);
      return;
    }
    const b = BLOCK.exec(line);
    if (b) onBlock(b[1], b[2], i, line);
    else onText(line, i, false);
  });
}

/** Replaces inline directives in one line, leaving code spans alone. */
function mapInline(line, fn) {
  return line
    .split(/(`[^`]*`)/)
    .map((part) => (part.startsWith("`") ? part : part.replace(INLINE, (_, pre, _all, kind, id) => pre + fn(kind, id))))
    .join("");
}

/** The sections a `::papyrus{…}` block renders, in source order, each with its functions. */
function papyrusSections(facts, attrs) {
  const all = [...facts.values()];
  return all
    .filter((s) => s.kind === "papyrus_section" && s.script === attrs.script && (!attrs.section || s.name === attrs.section))
    .sort((a, b) => a.order - b.order)
    .map((s) => ({
      ...s,
      functions: all.filter((f) => f.kind === "papyrus" && f.script === s.script && f.section === s.name),
    }))
    .filter((s) => s.notes.length || s.functions.length);
}

/** The papyrus facts a `::papyrus{…}` block renders, in source order. */
function papyrusFacts(facts, attrs) {
  return papyrusSections(facts, attrs).flatMap((s) => s.functions);
}

/**
 * Checks every directive on every page.
 * @param {{ path: string, url: string, body: string }[]} pages
 * @param {Map<string, object>} facts
 * @returns {{ errors: string[], renderedAt: Map<string, string> }}
 *   renderedAt maps a fact id to the URL (with anchor) where a block renders it.
 */
export function resolve(pages, facts) {
  const errors = [];
  const renderedAt = new Map();
  for (const page of pages) {
    walk(
      page.body,
      (kind, attrText, i) => {
        const where = `${page.path}:${i + 1}`;
        const spec = BLOCK_KINDS[kind];
        if (!spec) return errors.push(`${where}: unknown block directive ::${kind}`);
        const { attrs, rest } = parseAttrs(attrText);
        if (rest) errors.push(`${where}: ::${kind} has unreadable attributes: ${rest}`);
        for (const a of spec.required) if (!(a in attrs)) errors.push(`${where}: ::${kind} needs ${a}="…"`);
        for (const a of Object.keys(attrs))
          if (!spec.required.includes(a) && !spec.optional.includes(a)) errors.push(`${where}: ::${kind} has no attribute ${a}`);
        const shown = papyrusFacts(facts, attrs);
        if (papyrusSections(facts, attrs).length === 0) errors.push(`${where}: ::${kind}{${attrText}} matches no facts`);
        for (const f of shown) {
          if (renderedAt.has(f.id)) errors.push(`${where}: ${f.id} is already rendered at ${renderedAt.get(f.id)}`);
          else renderedAt.set(f.id, `${page.url}#${slug(f.name)}`);
        }
      },
      (line, i, code) => {
        if (code) return;
        if (/^\s*::/.test(line)) errors.push(`${page.path}:${i + 1}: malformed block directive: ${line.trim()}`);
        mapInline(line, (kind, id) => {
          if (!facts.has(`${kind}:${id}`)) errors.push(`${page.path}:${i + 1}: :${kind}[${id}] names no fact`);
          return "";
        });
      },
    );
  }
  return { errors, renderedAt };
}

const WRAP_AT = 100;

/** The declaration as Papyrus, one parameter per line once it is long. */
function papyrusSignature(f) {
  const params = f.params.map((p) => `${p.type} ${p.name}${p.default !== undefined ? ` = ${p.default}` : ""}`);
  const head = `${f.returns ? `${f.returns} ` : ""}function ${f.name}(`;
  const flat = `${head}${params.join(", ")}) Global Native`;
  if (flat.length <= WRAP_AT || params.length < 2) return flat;
  return `${head}${params.join(", \\\n    ")}) Global Native`;
}

const cell = (s) => s.replace(/\|/g, "\\|");

/**
 * Splits a function's comment into prose and per-parameter descriptions:
 * a `- name: text` line naming one of its parameters describes that parameter.
 */
function splitDoc(f) {
  const names = new Set(f.params.map((p) => p.name));
  const described = new Map();
  const prose = [];
  for (const line of f.doc.split("\n")) {
    const m = /^-\s*(\w+):\s*(.*)$/.exec(line.trim());
    if (m && names.has(m[1]) && !described.has(m[1])) described.set(m[1], m[2]);
    else prose.push(line);
  }
  return { prose: prose.join("\n").trim(), described };
}

/**
 * A section note as markdown. Notes laid out in columns (event tables, code
 * examples) keep their layout in a text block; plain notes become prose.
 */
function renderNote(note) {
  const laidOut = note.split("\n").some((l) => /^ {2,}\S/.test(l) || /\S {2,}\S/.test(l));
  return laidOut ? ["```text", note, "```"].join("\n") : note;
}

function renderPapyrusFunction(f, out) {
  out.push(`### ${f.name}`, "", "```papyrus", papyrusSignature(f), "```", "");
  const { prose, described } = splitDoc(f);
  if (prose) out.push(prose, "");
  if (f.params.length) {
    out.push("| Parameter | Type | Default | Description |", "| --- | --- | --- | --- |");
    for (const p of f.params)
      out.push(`| \`${p.name}\` | \`${p.type}\` | ${p.default !== undefined ? `\`${cell(p.default)}\`` : ""} | ${cell(described.get(p.name) ?? "")} |`);
    out.push("");
  }
}

function renderPapyrusBlock(facts, attrs) {
  const out = [];
  for (const sec of papyrusSections(facts, attrs)) {
    if (!attrs.section) out.push(`## ${sec.name}`, "");
    for (const note of sec.notes) out.push(renderNote(note), "");
    for (const f of sec.functions) renderPapyrusFunction(f, out);
  }
  return out.join("\n").trimEnd();
}

function renderInline(facts, renderedAt, kind, id) {
  const fact = facts.get(`${kind}:${id}`);
  const label = fact.label ?? fact.name ?? id;
  const at = renderedAt.get(`${kind}:${id}`);
  return at ? `[\`${label}\`](${at})` : `\`${label}\``;
}

/**
 * A page's markdown with every directive expanded. Call after `resolve`
 * returned no errors.
 */
export function expand(page, facts, renderedAt) {
  const out = [];
  walk(
    page.body,
    (kind, attrText) => {
      const { attrs } = parseAttrs(attrText);
      out.push(renderPapyrusBlock(facts, attrs));
    },
    (line, _i, code) => out.push(code ? line : mapInline(line, (kind, id) => renderInline(facts, renderedAt, kind, id))),
  );
  return out.join("\n");
}

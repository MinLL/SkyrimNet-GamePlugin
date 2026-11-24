// Parses a Papyrus API script (SkyrimNetApi.psc) into documentation facts.
//
// The script's own layout is the contract:
//   ; --- Section Name ---          starts a section
//   ; comment lines                 document the declaration directly below them
//   <type> function Name(...) Global Native
// A declaration may continue across lines with a trailing `\`. A declaration
// with no comment of its own, directly below another (no blank line between),
// shares that one's comment: ExecuteAction / ExecuteActionByUUID.
// A comment that documents no declaration (it ends at a blank line or a new
// section) is a note on its section: the Events section is nothing but notes.
//
// Anything else that is not a comment, a blank line or the Scriptname line is
// an error, so a new construct fails loudly instead of being skipped.

// `; --- Name ---`. The name may not start with a dash, so a short underline
// such as `; --------------` inside a note is not read as a section.
const SECTION = /^;\s*---\s+([^-\s].*?)\s+---\s*$/;
// The banner lines around a section name; short underlines inside a note are text.
const RULE = /^;\s*-{20,}\s*$/;
const SCRIPTNAME = /^scriptname\s+(\w+)/i;
const DECL =
  /^(?:(\w+(?:\[\])?)\s+)?function\s+(\w+)\s*\((.*)\)\s+global\s+native\s*$/i;

/** Joins `\` continuations, keeping the first line's number for messages. */
function logicalLines(text) {
  const out = [];
  let pending = null;
  text.split("\n").forEach((raw, i) => {
    const line = raw.replace(/\r$/, "");
    if (pending) {
      pending.text += " " + line.trim();
    } else {
      pending = { text: line, line: i + 1 };
    }
    if (/\\\s*$/.test(pending.text)) {
      pending.text = pending.text.replace(/\\\s*$/, "");
      return;
    }
    out.push(pending);
    pending = null;
  });
  if (pending) out.push(pending);
  return out;
}

/** Splits a parameter list on commas outside quotes. */
function splitParams(list) {
  const parts = [];
  let cur = "";
  let quoted = false;
  for (const ch of list) {
    if (ch === '"') quoted = !quoted;
    if (ch === "," && !quoted) {
      parts.push(cur);
      cur = "";
    } else {
      cur += ch;
    }
  }
  if (cur.trim()) parts.push(cur);
  return parts.map((p) => p.trim());
}

function parseParam(text, where) {
  const m = /^(\w+(?:\[\])?)\s+(\w+)(?:\s*=\s*(.+))?$/.exec(text);
  if (!m) throw new Error(`${where}: cannot read parameter "${text}"`);
  const param = { type: m[1], name: m[2] };
  if (m[3] !== undefined) param.default = m[3].trim();
  return param;
}

/** Strips `;` and one following space; a line of only spaces becomes empty. */
function commentText(line) {
  return line.replace(/^;\s?/, "").replace(/\s+$/, "");
}

/**
 * @param {string} text the .psc source
 * @param {string} file a path for error messages
 * @returns {{ script: string, sections: { name: string, notes: string[] }[], functions: object[] }}
 *   sections in source order; a note is one comment block, newlines kept
 */
export function parsePapyrus(text, file = "script.psc") {
  let script = null;
  let section = null;
  const sections = [];
  const functions = [];
  let comment = [];
  let previous = null; // the declaration directly above, if nothing intervened

  // A comment no declaration took becomes a note on the section it sits in.
  const keepAsNote = () => {
    const note = trimBlank(comment).join("\n");
    if (note && section) section.notes.push(note);
    comment = [];
  };

  for (const { text: raw, line } of logicalLines(text)) {
    const where = `${file}:${line}`;
    const t = raw.trim();
    if (t === "") {
      keepAsNote();
      previous = null;
      continue;
    }
    const sm = SCRIPTNAME.exec(t);
    if (sm) {
      script = sm[1];
      continue;
    }
    if (RULE.test(t)) continue;
    const sec = SECTION.exec(t);
    if (sec) {
      keepAsNote();
      section = { name: sec[1], notes: [] };
      sections.push(section);
      previous = null;
      continue;
    }
    if (t.startsWith(";")) {
      comment.push(commentText(t));
      previous = null;
      continue;
    }
    const d = DECL.exec(t);
    if (!d) throw new Error(`${where}: not a comment, section or native declaration: ${t}`);
    if (!script) throw new Error(`${where}: declaration before the Scriptname line`);
    const params = d[3].trim() === "" ? [] : splitParams(d[3]).map((p) => parseParam(p, where));
    let doc = trimBlank(comment).join("\n");
    if (!doc && previous) doc = previous.doc;
    const fn = {
      id: `papyrus:${script}.${d[2]}`,
      script,
      name: d[2],
      section: section?.name ?? null,
      returns: d[1] ?? null,
      params,
      signature: t.replace(/\s+/g, " "),
      doc,
      line,
    };
    functions.push(fn);
    comment = [];
    previous = fn;
  }

  keepAsNote();
  if (!script) throw new Error(`${file}: no Scriptname line`);
  const seen = new Set();
  for (const fn of functions) {
    if (seen.has(fn.name)) throw new Error(`${file}:${fn.line}: ${fn.name} is declared twice`);
    seen.add(fn.name);
  }
  return { script, sections, functions };
}

function trimBlank(lines) {
  let a = 0;
  let b = lines.length;
  while (a < b && lines[a] === "") a++;
  while (b > a && lines[b - 1] === "") b--;
  return lines.slice(a, b);
}

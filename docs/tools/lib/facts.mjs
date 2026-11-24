// Builds the public facts the docs embed, from files in this repository.
//
// These are the public half of the release snapshot described in
// fateless.ai docs/DOCS-PIPELINE.md. Facts that come from private sources
// (settings, decorators, dashboard menus) are merged in from a snapshot file
// when one is given; without one, only the public facts resolve.

import { readFileSync } from "node:fs";
import { join } from "node:path";
import { parsePapyrus } from "./papyrus.mjs";

/** The Papyrus scripts whose functions are documented, relative to the repo root. */
export const PAPYRUS_SOURCES = ["Source/Scripts/SkyrimNetApi.psc"];

/**
 * @param {string} root the repository root
 * @param {{ snapshot?: object }} [opts] facts from a release snapshot, merged in
 * @returns {Map<string, object>} fact id -> fact
 */
export function buildFacts(root, opts = {}) {
  const facts = new Map();
  for (const rel of PAPYRUS_SOURCES) {
    const { script, sections, functions } = parsePapyrus(readFileSync(join(root, rel), "utf8"), rel);
    sections.forEach((sec, order) => {
      const id = `papyrus_section:${script}.${sec.name}`;
      if (facts.has(id)) throw new Error(`${rel}: section "${sec.name}" appears twice`);
      facts.set(id, { kind: "papyrus_section", source: rel, script, name: sec.name, order, notes: sec.notes });
    });
    for (const fn of functions) facts.set(fn.id, { kind: "papyrus", source: rel, ...fn });
  }
  for (const [id, fact] of Object.entries(opts.snapshot?.facts ?? {})) {
    if (facts.has(id)) throw new Error(`snapshot fact ${id} collides with a fact built from this repo`);
    facts.set(id, fact);
  }
  return facts;
}

/** The facts as a stable JSON object, sorted by id. */
export function factsToJson(facts) {
  const out = {};
  for (const id of [...facts.keys()].sort()) {
    const { line, ...rest } = facts.get(id);
    out[id] = rest;
  }
  return { facts: out };
}

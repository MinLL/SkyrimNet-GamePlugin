#!/usr/bin/env node
// The docs tool. Run from anywhere in the repository:
//
//   node docs/tools/cli.mjs check                 every page, directive and link
//   node docs/tools/cli.mjs facts [--out f.json]  the public facts, as JSON
//   node docs/tools/cli.mjs render --out <dir>    pages with directives expanded,
//                                                 plus manifest.json, for a renderer
//
// `--snapshot <file>` merges a release snapshot's facts (settings, decorators,
// menus) into the public ones before checking or rendering.

import { mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { dirname, join, resolve as resolvePath } from "node:path";
import { fileURLToPath } from "node:url";
import { expand, resolve } from "./lib/directives.mjs";
import { buildFacts, factsToJson } from "./lib/facts.mjs";
import { ADULT_DIR, loadSite } from "./lib/site.mjs";

const ROOT = resolvePath(dirname(fileURLToPath(import.meta.url)), "../..");
const SITE = join(ROOT, "docs/site");

function option(args, name) {
  const i = args.indexOf(name);
  return i === -1 ? undefined : args[i + 1];
}

function load(args) {
  const snapshotFile = option(args, "--snapshot");
  const snapshot = snapshotFile ? JSON.parse(readFileSync(snapshotFile, "utf8")) : undefined;
  const facts = buildFacts(ROOT, { snapshot });
  const site = loadSite(SITE);
  const { errors, renderedAt } = resolve(site.pages, facts);
  return { facts, site, renderedAt, errors: [...site.errors, ...errors] };
}

function fail(errors) {
  for (const e of errors) console.error(e);
  console.error(`\n${errors.length} problem${errors.length === 1 ? "" : "s"} in docs/site`);
  process.exit(1);
}

const [command, ...args] = process.argv.slice(2);

if (command === "check") {
  const { facts, site, errors } = load(args);
  if (errors.length) fail(errors);
  console.log(`docs/site: ${site.pages.length} pages, ${facts.size} facts, no problems`);
} else if (command === "facts") {
  const json = JSON.stringify(factsToJson(buildFacts(ROOT)), null, 2) + "\n";
  const out = option(args, "--out");
  if (out) writeFileSync(out, json);
  else process.stdout.write(json);
} else if (command === "render") {
  const out = option(args, "--out");
  if (!out) fail(["render needs --out <dir>"]);
  const { facts, site, renderedAt, errors } = load(args);
  if (errors.length) fail(errors);
  const pages = [];
  for (const page of site.pages) {
    const file = join(out, "pages", page.path);
    mkdirSync(dirname(file), { recursive: true });
    writeFileSync(file, expand(page, facts, renderedAt));
    pages.push({
      path: page.path,
      url: page.url,
      title: page.meta.title,
      audience: page.meta.audience,
      indexed: !page.path.startsWith(ADULT_DIR),
    });
  }
  writeFileSync(join(out, "manifest.json"), JSON.stringify({ nav: site.nav, pages }, null, 2) + "\n");
  console.log(`rendered ${pages.length} pages to ${out}`);
} else {
  fail([`unknown command "${command ?? ""}": use check, facts or render`]);
}

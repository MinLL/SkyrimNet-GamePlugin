import assert from "node:assert/strict";
import { mkdirSync, mkdtempSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { dirname, join } from "node:path";
import { test } from "node:test";
import { fileURLToPath } from "node:url";
import { expand, resolve, slug } from "../lib/directives.mjs";
import { buildFacts } from "../lib/facts.mjs";
import { loadSite, pageUrl } from "../lib/site.mjs";

const ROOT = join(dirname(fileURLToPath(import.meta.url)), "../../..");
const FACTS = buildFacts(ROOT);

/** A throwaway docs/site with the given files. */
function site(files) {
  const dir = mkdtempSync(join(tmpdir(), "docs-site-"));
  for (const [path, text] of Object.entries(files)) {
    mkdirSync(dirname(join(dir, path)), { recursive: true });
    writeFileSync(join(dir, path), text);
  }
  return loadSite(dir);
}

const page = (body, meta = "title: T\naudience: modder") => `---\n${meta}\n---\n${body}\n`;
const nav = (...pages) => `- title: S\n  pages:\n${pages.map((p) => `    - ${p}`).join("\n")}\n`;

test("the real docs/site passes", () => {
  const s = loadSite(join(ROOT, "docs/site"));
  const { errors } = resolve(s.pages, FACTS);
  assert.deepEqual([...s.errors, ...errors], []);
});

test("every Papyrus function is rendered on exactly one page", () => {
  const s = loadSite(join(ROOT, "docs/site"));
  const { renderedAt } = resolve(s.pages, FACTS);
  const papyrus = [...FACTS.keys()].filter((id) => id.startsWith("papyrus:"));
  assert.deepEqual(papyrus.filter((id) => !renderedAt.has(id)), []);
});

test("a directive naming a missing fact fails with page and line", () => {
  const s = site({ "nav.yaml": nav("a.md"), "a.md": page("intro\n\nsee :papyrus[SkyrimNetApi.NoSuchThing]") });
  const { errors } = resolve(s.pages, FACTS);
  assert.deepEqual(errors, ["a.md:3: :papyrus[SkyrimNetApi.NoSuchThing] names no fact"]);
});

test("directives inside code are not read", () => {
  const body = "`:papyrus[X.Y]`\n\n```md\n::papyrus{script=\"Nope\"}\n:papyrus[X.Y]\n```";
  const s = site({ "nav.yaml": nav("a.md"), "a.md": page(body) });
  assert.deepEqual(resolve(s.pages, FACTS).errors, []);
});

test("an unknown block directive and a missing attribute fail", () => {
  const s = site({ "nav.yaml": nav("a.md"), "a.md": page('::settings{section="x"}\n::papyrus{section="x"}') });
  const { errors } = resolve(s.pages, FACTS);
  assert.ok(errors.some((e) => /unknown block directive ::settings/.test(e)));
  assert.ok(errors.some((e) => /::papyrus needs script=/.test(e)));
});

test("a fact rendered by two blocks fails", () => {
  const block = '::papyrus{script="SkyrimNetApi" section="Action Management"}';
  const s = site({ "nav.yaml": nav("a.md", "b.md"), "a.md": page(block), "b.md": page(block) });
  assert.ok(resolve(s.pages, FACTS).errors.some((e) => /already rendered at \/docs\/a#/.test(e)));
});

test("inline directives link to where the block renders the fact", () => {
  const s = site({
    "nav.yaml": nav("ref.md", "guide.md"),
    "ref.md": page('::papyrus{script="SkyrimNetApi" section="Action Management"}'),
    "guide.md": page("Call :papyrus[SkyrimNetApi.RegisterAction] first."),
  });
  const { errors, renderedAt } = resolve(s.pages, FACTS);
  assert.deepEqual(errors, []);
  const guide = s.pages.find((p) => p.path === "guide.md");
  assert.match(expand(guide, FACTS, renderedAt), /Call \[`RegisterAction`\]\(\/docs\/ref#registeraction\) first\./);
  const ref = expand(s.pages.find((p) => p.path === "ref.md"), FACTS, renderedAt);
  assert.match(ref, /### RegisterAction\n\n```papyrus\nint function RegisterAction\(String actionName, \\\n {4}String description/);
  assert.match(ref, /\| `actionName` \| `String` \| {2}\| Will be visible to the LLM/);
});

test("section notes render: plain ones as prose, laid-out ones in a text block", () => {
  const s = site({ "nav.yaml": nav("ref.md"), "ref.md": page('::papyrus{script="SkyrimNetApi"}') });
  const { errors, renderedAt } = resolve(s.pages, FACTS);
  assert.deepEqual(errors, []);
  const ref = expand(s.pages[0], FACTS, renderedAt);
  assert.match(ref, /## Hotkey Trigger Functions\n\nThese functions trigger hotkey actions/);
  assert.match(ref, /## Events\n\n```text\nPackage events\n[\s\S]*SkyrimNet_OnPackageRemoved[\s\S]*?```/);
});

test("every page must be in the nav, once, and the nav must point at real pages", () => {
  const s = site({ "nav.yaml": nav("a.md", "a.md", "gone.md"), "a.md": page("x"), "b.md": page("y") });
  assert.ok(s.errors.includes("nav.yaml: a.md is listed twice"));
  assert.ok(s.errors.includes("nav.yaml: gone.md does not exist"));
  assert.ok(s.errors.some((e) => e.startsWith("b.md: not in nav.yaml")));
});

test("adult pages stay out of the nav and need not be in it", () => {
  const ok = site({ "nav.yaml": nav("a.md"), "a.md": page("x"), "adult/n.md": page("y", "title: N\naudience: player") });
  assert.deepEqual(ok.errors, []);
  const bad = site({ "nav.yaml": nav("a.md", "adult/n.md"), "a.md": page("x"), "adult/n.md": page("y") });
  assert.ok(bad.errors.some((e) => /stays out of the nav/.test(e)));
});

test("frontmatter, links and aging phrases are checked", () => {
  const s = site({
    "nav.yaml": nav("a.md", "b.md"),
    "a.md": page("See [b](b.md#x), [gone](missing.md) and [web](https://x.y).\n\nThis is currently true.", "title: A\naudience: reader"),
    "b.md": page("fine"),
  });
  assert.ok(s.errors.includes("a.md: audience must be one of player, modder"));
  assert.ok(s.errors.some((e) => /^a\.md:5: link to missing\.md/.test(e)));
  assert.ok(!s.errors.some((e) => /link to b\.md/.test(e)));
  assert.ok(s.errors.some((e) => /^a\.md:7: "currently" ages/.test(e)));
});

test("urls and anchors", () => {
  assert.equal(pageUrl("modding/papyrus-api.md"), "/docs/modding/papyrus-api");
  assert.equal(pageUrl("index.md"), "/docs");
  assert.equal(pageUrl("modding/index.md"), "/docs/modding");
  assert.equal(slug("RegisterAction"), "registeraction");
  assert.equal(slug("LLM Interaction"), "llm-interaction");
});

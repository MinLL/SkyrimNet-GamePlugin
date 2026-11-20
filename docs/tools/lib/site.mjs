// Loads docs/site and checks everything about it that needs no facts:
// the navigation, each page's frontmatter, links between pages, and the
// style rules a machine can hold.

import { existsSync, readdirSync, readFileSync, statSync } from "node:fs";
import { dirname, join, posix, relative } from "node:path";
import { parse as parseYaml } from "yaml";

/** Files in docs/site that are about the docs rather than pages of them. */
export const NOT_PAGES = new Set(["README.md", "STYLE.md"]);
export const AUDIENCES = ["player", "modder"];
/** Pages under this folder are served unindexed and kept out of the nav. */
export const ADULT_DIR = "adult/";

const FRONTMATTER = /^---\n([\s\S]*?)\n---\n?/;

/** The URL a page is served at. `index.md` is its folder. */
export function pageUrl(path) {
  const stem = path.replace(/\.md$/, "").replace(/(^|\/)index$/, "");
  return stem ? `/docs/${stem}` : "/docs";
}

function listMarkdown(dir, base = dir) {
  const out = [];
  for (const name of readdirSync(dir)) {
    const full = join(dir, name);
    if (statSync(full).isDirectory()) out.push(...listMarkdown(full, base));
    else if (name.endsWith(".md")) out.push(relative(base, full).split("\\").join("/"));
  }
  return out.sort();
}

/** Flattens nav.yaml into the ordered list of page paths it places. */
function navPaths(nav, errors) {
  const paths = [];
  if (!Array.isArray(nav)) {
    errors.push("nav.yaml: must be a list of sections");
    return paths;
  }
  for (const [i, section] of nav.entries()) {
    if (typeof section?.title !== "string" || !Array.isArray(section.pages)) {
      errors.push(`nav.yaml: section ${i + 1} needs a title and a list of pages`);
      continue;
    }
    for (const p of section.pages) {
      if (typeof p !== "string") errors.push(`nav.yaml: "${section.title}" lists a page that is not a path`);
      else paths.push(p);
    }
  }
  return paths;
}

/**
 * @param {string} siteDir the docs/site directory
 * @returns {{ pages: object[], nav: object[], errors: string[] }}
 */
export function loadSite(siteDir) {
  const errors = [];
  const navFile = join(siteDir, "nav.yaml");
  const nav = existsSync(navFile) ? parseYaml(readFileSync(navFile, "utf8")) : [];
  if (!existsSync(navFile)) errors.push("nav.yaml: missing");
  const placed = navPaths(nav, errors);

  const files = listMarkdown(siteDir).filter((p) => !NOT_PAGES.has(p));
  const pages = [];
  for (const path of files) {
    const text = readFileSync(join(siteDir, path), "utf8").replace(/\r\n/g, "\n");
    const fm = FRONTMATTER.exec(text);
    let meta = {};
    if (!fm) errors.push(`${path}: no frontmatter`);
    else {
      try {
        meta = parseYaml(fm[1]) ?? {};
      } catch (e) {
        errors.push(`${path}: frontmatter is not YAML: ${e.message}`);
      }
    }
    pages.push({
      path,
      url: pageUrl(path),
      meta,
      body: fm ? text.slice(fm[0].length) : text,
      bodyStartLine: fm ? fm[0].split("\n").length : 1,
    });
  }

  const known = new Set(files);
  const seen = new Set();
  for (const p of placed) {
    if (!known.has(p)) errors.push(`nav.yaml: ${p} does not exist`);
    if (seen.has(p)) errors.push(`nav.yaml: ${p} is listed twice`);
    if (p.startsWith(ADULT_DIR)) errors.push(`nav.yaml: ${p} is in ${ADULT_DIR}, which stays out of the nav`);
    seen.add(p);
  }
  for (const p of files) {
    if (!seen.has(p) && !p.startsWith(ADULT_DIR)) errors.push(`${p}: not in nav.yaml; every page is placed by an editor`);
  }

  for (const page of pages) errors.push(...checkPage(page, known));
  return { pages, nav, errors };
}

/** Frontmatter, links and style for one page. */
export function checkPage(page, known) {
  const errors = [];
  const { path, meta } = page;
  if (typeof meta.title !== "string" || !meta.title.trim()) errors.push(`${path}: frontmatter needs a title`);
  if (!AUDIENCES.includes(meta.audience)) errors.push(`${path}: audience must be one of ${AUDIENCES.join(", ")}`);
  if (meta.covers !== undefined && !(Array.isArray(meta.covers) && meta.covers.every((c) => typeof c === "string")))
    errors.push(`${path}: covers must be a list of fact ids or prefixes`);
  if (meta.reviewed !== undefined && typeof meta.reviewed !== "string")
    errors.push(`${path}: reviewed must be a release name such as beta27`);

  let fence = null;
  page.body.split("\n").forEach((line, i) => {
    const at = `${path}:${page.bodyStartLine + i}`;
    const f = /^\s*(```|~~~)/.exec(line);
    if (fence) {
      if (f && f[1] === fence) fence = null;
      return;
    }
    if (f) {
      fence = f[1];
      return;
    }
    const prose = line.replace(/`[^`]*`/g, "");
    for (const m of prose.matchAll(/\]\(([^)\s]+)\)/g)) {
      const target = m[1];
      if (/^[a-z]+:/i.test(target) || target.startsWith("#") || target.startsWith("/")) continue;
      const file = posix.normalize(posix.join(dirname(path), target.split("#")[0]));
      if (!known.has(file)) errors.push(`${at}: link to ${target} does not resolve to a docs page`);
    }
    // Phrasing that is true on the day it is written and wrong a release later.
    for (const m of prose.matchAll(/\b(currently|new in|recently|coming soon)\b/gi))
      errors.push(`${at}: "${m[1]}" ages; say what is true, or name the version`);
  });
  return errors;
}

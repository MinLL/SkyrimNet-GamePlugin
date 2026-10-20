import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { test } from "node:test";
import { parsePapyrus } from "../lib/papyrus.mjs";

const API = readFileSync(new URL("../../../Source/Scripts/SkyrimNetApi.psc", import.meta.url), "utf8");

test("reads every native in SkyrimNetApi.psc, continuations included", () => {
  const { script, functions, sections } = parsePapyrus(API);
  assert.equal(script, "SkyrimNetApi");
  // `grep -ci "global native"` counts the same declarations. A change to this
  // number is a change to the public API: update it on purpose.
  assert.equal(functions.length, 130);
  assert.ok(functions.every((f) => f.section), "every function sits in a section");
  assert.ok(sections.length > 20);
});

test("a declaration split with backslashes keeps all its parameters", () => {
  const fn = parsePapyrus(API).functions.find((f) => f.name === "RegisterAction");
  assert.equal(fn.params.length, 12);
  assert.deepEqual(fn.params.at(-1), { type: "String", name: "tags", default: '""' });
  assert.equal(fn.section, "Action Management");
  assert.match(fn.doc, /^Register an action to be performed by an NPC/);
});

test("a declaration directly under another, with no comment, shares its comment", () => {
  const fns = parsePapyrus(API).functions;
  const a = fns.find((f) => f.name === "ExecuteAction");
  const b = fns.find((f) => f.name === "ExecuteActionByUUID");
  assert.ok(a.doc);
  assert.equal(b.doc, a.doc);
});

test("a blank line ends a comment: the next declaration does not inherit it", () => {
  const src = "Scriptname S\n; --- A ---\n; about f\nint function f() Global Native\n\nint function g() Global Native\n";
  const [f, g] = parsePapyrus(src).functions;
  assert.equal(f.doc, "about f");
  assert.equal(g.doc, "");
});

test("a comment no declaration takes is kept as its section's note", () => {
  const src = [
    "Scriptname S",
    "; " + "-".repeat(40),
    "; --- A ---",
    "; " + "-".repeat(40),
    "",
    "; Intro to A.",
    "",
    "; about f",
    "int function f() Global Native",
    "; --- B ---",
    "; Events",
    "; ------",
    ";     indented line",
  ].join("\n");
  const { sections } = parsePapyrus(src);
  assert.deepEqual(sections, [
    { name: "A", notes: ["Intro to A."] },
    { name: "B", notes: ["Events\n------\n    indented line"] },
  ]);
});

test("the Events section, which has no functions, keeps its documentation", () => {
  const events = parsePapyrus(API).sections.find((s) => s.name === "Events");
  assert.equal(events.notes.length, 1);
  assert.match(events.notes[0], /SkyrimNet_OnPackageRemoved/);
  assert.match(events.notes[0], /RegisterForModEvent\("SkyrimNet_OnPackageRemoved"/);
});

test("anything that is not a comment, section or native declaration fails loudly", () => {
  const src = "Scriptname S\n; --- A ---\nint function f() Global\n";
  assert.throws(() => parsePapyrus(src, "S.psc"), /S\.psc:3: not a comment, section or native declaration/);
});

test("a name declared twice fails", () => {
  const src = "Scriptname S\nint function f() Global Native\nint function f(int a) Global Native\n";
  assert.throws(() => parsePapyrus(src), /f is declared twice/);
});

test("a function with no return type parses", () => {
  const src = "Scriptname S\nfunction f(Actor akActor, float x = 1.5) Global Native\n";
  const [f] = parsePapyrus(src).functions;
  assert.equal(f.returns, null);
  assert.deepEqual(f.params, [
    { type: "Actor", name: "akActor" },
    { type: "float", name: "x", default: "1.5" },
  ]);
});

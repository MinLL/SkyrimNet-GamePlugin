# Release-note fragments

Release notes are written in the PR, not reconstructed at release time. A PR that changes anything a
tester would notice adds or edits one file here. The Core repo's `/changelog` renders the fragments
of both repos between two tags into the Discord post and lists merged PRs that carry no fragment.

The full format, area list and voice rules live in the Core repo at `changelog.d/README.md`. The
short version:

- One file per feature, named after the feature. A follow-up PR edits it. The file always describes
  the feature as it is now.
- Titles typed `ci`, `build`, `chore`, `refactor`, `docs`, `ai_docs`, `test` or `style` need no
  fragment. A `feat` or `fix` a tester cannot notice puts `Release-note: none — <reason>` on its own
  line in the PR body; a PR covered by a fragment it did not touch puts
  `Release-note: changelog.d/<file>.md`.
- Credits resolve through the Core repo's `changelog.d/CREDITS.yaml`. Set `credit:` when you ship
  someone else's work.

```markdown
---
title: Carriage occupants render as seated
area: Dialogue
kind: change
credit: [Gerkinfeltser]
---
Prompts describe a carriage passenger as seated rather than standing.
```

| Key | Values |
|-----|--------|
| `title` | Section heading for `feature` and `breaking`; bold lead for `change` and `fix` bullets. |
| `area` | `Dialogue`, `Speech & Audio`, `Content Library & Plugin Hub`, `Dashboard`, `LLM & Routing`, `Game Integration`, `For Mod Authors`, `Other`. |
| `kind` | `feature` — own section. `change` — one bullet under its area. `fix` — one bullet under Bug Fixes. `breaking` — under Breaking Changes. |
| `credit` | GitHub logins or literal `@handles`. Defaults to the author of the commit that added the file. |

Write plain declaratives for a tester about to load the build: what you can now do in the situation
you would do it, where it is, what is different from before, what is not done yet. Nothing else.
Lead with the reader's situation, never the mechanism: "Press the Capture Crosshair hotkey while
the Book Menu is open and your character reads the book" rather than how the capture works. A
`fix` is one line and its title is the symptom as the player saw it; a `feature` is a lead of at
most two sentences and at most six bullets. `> Note for <=rcN testers:` right after the lead when
a returning tester would otherwise report the change as a bug.

# SkyrimNet docs

The source of SkyrimNet's documentation, published at
[fateless.ai/docs](https://fateless.ai/docs). Fixes and new pages are
welcome as pull requests; collaborators review and merge them.

## A page

A page is a markdown file with frontmatter:

```yaml
---
title: The diary
audience: player          # player or modder
covers: [setting:diary.*] # optional: facts this page explains in prose
---
```

Every page is placed in [`nav.yaml`](nav.yaml). A page that is not in the
nav fails the check. Pages under `adult/` are the exception: they are served
unindexed and never linked from the nav.

`reviewed:` (a release name such as `beta27`) records the release at which a
person last confirmed the page is right. Only a person sets it.

Write for the reader in [STYLE.md](STYLE.md).

## Facts, not copies

Anything the game itself defines (a function's signature, a setting's
default, a menu's name) is embedded, never typed out, so a page cannot fall
behind the game:

| Write | Renders |
| --- | --- |
| `:papyrus[SkyrimNetApi.RegisterAction]` | a link to that function's reference |
| `::papyrus{script="SkyrimNetApi"}` on its own line | the reference for the whole script, by section |
| `::papyrus{script="SkyrimNetApi" section="Action Management"}` | one section of it |

A directive that names something that does not exist fails the check, with
the page and line. Settings, menus, decorators and models get directives of
the same shape as the release snapshots that carry them come online.

## Checking your change

With Node 22 or later:

```sh
cd docs/tools
npm ci
npm test
node cli.mjs check
```

CI runs the same on every pull request that touches `docs/`.

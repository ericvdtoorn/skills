---
name: gitmoji-commits
description: Reference for the evantoor commit-message convention — single-line commits prefixed with a gitmoji, one functional purpose per commit. Use when writing a commit message, reviewing whether a change should be one commit or several, or wiring up a commit-msg lint.
---

# Gitmoji Commits

The convention:

1. **One line.** No body. If you feel the urge to write a body, the commit is probably too big — split it.
2. **One gitmoji** at the start, then a space, then the subject in imperative mood.
3. **One functional purpose** per commit. If the subject naturally contains "and", split.

Trailers (`Co-Authored-By:`, `Signed-off-by:`) are not used by default. Add them only if the user asks.

## Anatomy

```
<emoji> <imperative subject under ~72 chars total>
```

Examples:

```
✨ add gitmoji-commits skill
🐛 fix off-by-one in pagination cursor
♻️ extract triage label mapping into module
📝 document mise/logs tail pattern
🔧 pin uv to 0.5 in .mise.toml
🔥 remove unused legacy import helper
✅ cover the merge-conflict path in tdd skill
⬆️ bump bun to 1.2
🚑 hotfix: handle null user in session middleware
```

Style:
- Lowercase first word after the emoji (proper nouns keep their case).
- Imperative ("add", not "added" / "adds").
- No trailing period.
- Keep under ~72 chars including the emoji.

## Picking the emoji

Pick the one that best describes the **dominant** change. If two emojis fit equally, the commit might be doing two things — split it.

| Emoji | Shortcode | Use for |
| --- | --- | --- |
| ✨ | `:sparkles:` | new feature, new capability |
| 🐛 | `:bug:` | bug fix |
| 🚑 | `:ambulance:` | critical hotfix |
| ♻️ | `:recycle:` | refactor (no behaviour change) |
| 🎨 | `:art:` | improve structure/formatting of code |
| 🔥 | `:fire:` | remove code or files |
| 📝 | `:memo:` | docs (markdown, comments, READMEs) |
| ✅ | `:white_check_mark:` | add or update tests |
| ⚡ | `:zap:` | performance improvement |
| 🔧 | `:wrench:` | configuration / tooling files |
| 🏗️ | `:building_construction:` | architectural change |
| 💄 | `:lipstick:` | UI / styling change |
| 🚸 | `:children_crossing:` | UX / accessibility |
| 🔒 | `:lock:` | security fix or hardening |
| ⬆️ | `:arrow_up:` | upgrade a dependency |
| ⬇️ | `:arrow_down:` | downgrade a dependency |
| ➕ | `:heavy_plus_sign:` | add a dependency |
| ➖ | `:heavy_minus_sign:` | remove a dependency |
| 🚧 | `:construction:` | work in progress (avoid on main) |
| 🔖 | `:bookmark:` | release / version tag |
| ⏪ | `:rewind:` | revert |
| 💚 | `:green_heart:` | fix CI |
| 🔀 | `:twisted_rightwards_arrows:` | merge |

Use the unicode emoji directly — it's shorter on the line and renders everywhere. Shortcodes are equivalent for tools that prefer them.

Full reference: [gitmoji.dev](https://gitmoji.dev).

## Functional isolation

A commit should have **one** functional purpose. The subject line is the test:

- ✅ `✨ add gitmoji-commits skill` — single purpose
- ✅ `♻️ extract triage labels into module` — single purpose
- ❌ `✨ add skill and refactor mise hook` — two purposes, split
- ❌ `🐛 fix login and add password reset` — two purposes, split

When you're tempted to write `and`, `also`, `+`, or a multi-line body — split the change into two commits instead. Use `git add -p` to stage them separately.

### When a change really is one purpose but feels big

Some changes touch many files in service of one idea (a rename, a single API contract change, a dependency upgrade that ripples). Those are one commit even if the diff is large — the subject still describes one purpose:

```
♻️ rename setup-matt-pocock-skills → setup-evantoor-skills
```

If you can't summarise the change in a single imperative line, that's the signal to split — not the line count of the diff.

## What about PR descriptions?

Bodies belong in PR descriptions, not commit messages. The PR description is where you explain *why*, link issues, list test plans, and so on. Commit messages stay one-line.

## Wiring (optional)

If a repo wants to enforce this at commit time, install a `commit-msg` hook that rejects messages without a leading emoji and a one-line subject. Don't auto-install — ask the user first; some repos already have conventions like Conventional Commits and you don't want to silently override.

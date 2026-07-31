---
"evantoor-skills": minor
---

**`mise-tasks`** now covers `#USAGE` arg declarations. Tasks with a defined interface declare their flags and positional args in the header — mise validates input, generates `--help`, and injects each value as a `usage_<name>` env var — instead of hand-parsing `"$@"`. Raw `"$@"` stays right for pure passthrough wrappers (`bun test "$@"`), where the wrapped tool owns arg parsing.

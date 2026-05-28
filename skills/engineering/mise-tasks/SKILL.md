---
name: mise-tasks
description: Reference for authoring and running mise file tasks in repos that follow the evantoor tooling convention. Use when creating a new task, running a task, or wiring up a build/test/dev command. Covers file-task layout under `mise/tasks/`, the `mise/logs/<task>.log` output convention, and the tail pattern that emits the log path on the last lines so agents don't re-run a task just to inspect its full output.
---

# Mise File Tasks

This skill is the reference for repos set up by `/setup-evantoor-skills` with mise tooling. It covers two things:

1. **Authoring** — how to write a new file task that follows the logging + tail convention
2. **Invoking** — how to run tasks and read their output efficiently

If `mise/tasks/` doesn't exist in this repo, the tooling section of `/setup-evantoor-skills` hasn't been run. Stop and run it first.

## Conventions

- **Location**: `mise/tasks/<name>` (no extension) or `mise/tasks/<name>.sh`. Both forms work; mise picks them up via the `task_config.includes` setting in `.mise.toml`.
- **Logs**: every task writes its full stdout+stderr to `mise/logs/<name>.log`. `mise/logs/*.log` is gitignored.
- **Tail pattern**: the last lines of every task's terminal output state the log path and a tail command. Agents reading truncated output never have to re-run the task to get more context — they can `tail -200 mise/logs/<name>.log` instead.
- **Execution**: use `mise run <name>` (preferred — picks up env, pinned tool versions, and the task file all at once). For ad-hoc commands that aren't tasks, use `mise exec -- <command>`.

## Authoring a task

Use this template. Replace `<name>` and the body; keep the header and footer intact.

```bash
#!/usr/bin/env bash
#MISE description="<one-line summary shown in `mise tasks`>"
#MISE alias="<optional short alias>"
set -euo pipefail

TASK_NAME="$(basename "$0" .sh)"
LOG_DIR="${MISE_PROJECT_ROOT:-$PWD}/mise/logs"
LOG="$LOG_DIR/$TASK_NAME.log"
mkdir -p "$LOG_DIR"

# Run the body, capturing stdout+stderr to both terminal and log
{
  # ---- task body starts here ----

  echo "running $TASK_NAME"
  # e.g. bun test, uv run pytest, etc.

  # ---- task body ends here ----
} 2>&1 | tee "$LOG"

# Tail block — keep this verbatim at the end of every task
echo
echo "── log written to $LOG"
echo "── tail with: tail -200 $LOG"
```

### Why the tail block matters

When an agent runs a task and the output gets truncated (by terminal scrollback or by Claude's tool-result cap), the last few lines survive. By forcing the log path into those lines, the agent always knows where the full output lives. No need to re-run with `2>&1 > somewhere.log` after the fact.

### What goes in `mise/tasks/<name>` vs `package.json` / `Makefile`

- **mise tasks** — anything that needs the project's pinned tool versions (bun, uv, python), needs the logging convention, or is run from an agent context. Default to mise.
- **package.json scripts** — keep around if `bun run` workflows already exist, but prefer mise for new tasks. Mise can call bun scripts via `bun run …` inside a task body.
- **Makefile** — avoid for new work in this convention.

## Invoking a task

```bash
mise tasks                   # list all tasks (including description + alias)
mise run <name>              # run a task by name or alias
mise run <name> -- --flag x  # forward args after `--`
mise exec -- <cmd>           # run an ad-hoc command in the mise env (no task)
```

After a task completes, if you only need the tail:

```bash
tail -200 mise/logs/<name>.log
```

If you need the whole log, read it with the `Read` tool (don't `cat` it through Bash).

## Common patterns

### Task that runs JS via bun

```bash
#!/usr/bin/env bash
#MISE description="run JS tests"
set -euo pipefail
TASK_NAME="$(basename "$0" .sh)"; LOG="${MISE_PROJECT_ROOT:-$PWD}/mise/logs/$TASK_NAME.log"
mkdir -p "$(dirname "$LOG")"
{
  bun test "$@"
} 2>&1 | tee "$LOG"
echo; echo "── log written to $LOG"; echo "── tail with: tail -200 $LOG"
```

### Task that runs Python via uv

```bash
#!/usr/bin/env bash
#MISE description="run python tests"
set -euo pipefail
TASK_NAME="$(basename "$0" .sh)"; LOG="${MISE_PROJECT_ROOT:-$PWD}/mise/logs/$TASK_NAME.log"
mkdir -p "$(dirname "$LOG")"
{
  uv run pytest "$@"
} 2>&1 | tee "$LOG"
echo; echo "── log written to $LOG"; echo "── tail with: tail -200 $LOG"
```

### Composite task

mise supports `depends` in the header:

```bash
#!/usr/bin/env bash
#MISE description="lint + test + build"
#MISE depends=["lint", "test", "build"]
set -euo pipefail
# This task body can be empty when `depends` does the work, but still emit the tail block
TASK_NAME="$(basename "$0" .sh)"; LOG="${MISE_PROJECT_ROOT:-$PWD}/mise/logs/$TASK_NAME.log"
mkdir -p "$(dirname "$LOG")"
echo "all checks passed" | tee "$LOG"
echo; echo "── log written to $LOG"; echo "── tail with: tail -200 $LOG"
```

## When to deviate

- **Long-running watch tasks** (dev servers) — drop the `tee` to file and just stream to terminal. Logging a continuously-growing file is rarely useful, and the log path footer doesn't apply to processes that never exit. Document the deviation with a comment in the task body.
- **Tasks that emit huge binary output** (codegen, compilation) — write to the log file directly and `tail`/`grep` from there in the terminal. Don't `tee` megabytes of bytes through the agent's tool-result buffer.

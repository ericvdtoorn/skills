# Tooling

This repo uses [mise](https://mise.jdx.dev) for tool management and task running.

## Layout

- `mise.toml` — pinned tool versions (bun, uv, python, …) and task config
- `mise/tasks/` — file tasks (each task is its own executable file)
- `mise/logs/` — task output (gitignored; `*.log`)

## Conventions

- **JS deps**: bun. Use `bun install`, `bun add`, `bun run`. Avoid `npm` / `pnpm` / `yarn` for new work.
- **Python deps**: uv. Use `uv add`, `uv sync`, `uv run`. Avoid `pip` / `poetry` / `pipenv` for new work.
- **Running commands**: prefer `mise run <task>` if a matching task exists. Otherwise, just run the command directly — a `PreToolUse` hook activates mise for every Bash invocation, so commands like `bun test` or `uv run pytest` automatically resolve to the project's pinned versions. You don't need to remember `mise exec --`.
- **Authoring tasks**: see the `mise-tasks` skill for the file-task template, including the logging + tail convention. Every task writes to `mise/logs/<name>.log` and prints the log path on its last lines so agents don't re-run the task just to see more of its output.

## For agents

When the user asks to run, build, test, or otherwise execute something:

1. Run `mise tasks` to see what tasks exist.
2. If one matches the user's intent, prefer `mise run <task>` over a raw command — tasks are documented, logged, and reusable.
3. If no task matches, run the command directly (the mise-activation hook handles tool resolution). Consider creating a task (`/mise-tasks` skill) if the user is likely to want it again.
4. After a task runs, if the output was truncated, read the full log from `mise/logs/<task>.log` rather than re-running.

## Discovery

- List tasks: `mise tasks`
- Show a task's source: `mise tasks info <name>`
- List tools the repo pins: `mise ls`
- Install missing tools: `mise install`
- Trust the project's mise config (one-time per machine): `mise trust`

#!/usr/bin/env bash
#MISE description="<one-line summary shown in `mise tasks`>"
#MISE alias="<optional short alias — delete this line if not needed>"
set -euo pipefail

# Standard header — keep verbatim across all tasks.
TASK_NAME="$(basename "$0" .sh)"
LOG_DIR="${MISE_PROJECT_ROOT:-$PWD}/mise/logs"
LOG="$LOG_DIR/$TASK_NAME.log"
mkdir -p "$LOG_DIR"

{
  # ---- task body starts here ----

  echo "running $TASK_NAME"
  # Replace with the actual command(s) for this task, e.g.:
  #   bun test "$@"
  #   uv run pytest "$@"
  #   mise exec -- some-other-tool

  # ---- task body ends here ----
} 2>&1 | tee "$LOG"

# Tail block — keep verbatim. Tells agents where the full log lives so they
# don't re-run the task just to inspect more output.
echo
echo "── log written to $LOG"
echo "── tail with: tail -200 $LOG"

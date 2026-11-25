#!/usr/bin/env bash
# Run a command, keep the full log, print only a short summary.
set -uo pipefail

if [ "$#" -eq 0 ]; then
  echo "usage: $0 <command> [args...]" >&2
  exit 2
fi

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mkdir -p "$ROOT/.test-output"
LOG="$ROOT/.test-output/$(date +%Y%m%d-%H%M%S)-$$.log"

"$@" >"$LOG" 2>&1
STATUS=$?

echo "Command: $*"
if [ "$STATUS" -eq 0 ]; then
  echo "Status: PASS"
else
  echo "Status: FAIL (exit $STATUS)"
fi
echo "Log: $LOG"

if [ "$STATUS" -ne 0 ]; then
  echo "--- first failures ---"
  if grep -q -E '(^|[^A-Za-z])(FAIL|FAILED|✗|✕|●|AssertionError|Error:|E   )' "$LOG"; then
    grep -n -E '(^|[^A-Za-z])(FAIL|FAILED|✗|✕|●|AssertionError|Error:|E   )' "$LOG" | head -15
  else
    echo "(no failure marker found; showing last 15 lines)"
    tail -15 "$LOG"
  fi
fi

exit "$STATUS"

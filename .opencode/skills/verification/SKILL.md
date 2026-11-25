---
name: Verification
description: Use when a task needs verification or tests. Runs only targeted checks through scripts/test-summary.sh, keeps full logs out of the conversation, and never runs the full suite by default.
---

# Verification

## Default

- Do not run the full test suite. CI or the user owns it.
- Do not create or modify test files unless the user asks.
- Run only the smallest check related to the change.

## Always use the wrapper

From the project root:

```bash
bash scripts/test-summary.sh <command...>
```

Examples:

```bash
bash scripts/test-summary.sh bun test src/foo.test.ts
bash scripts/test-summary.sh npx vitest run src/foo.test.ts
bash scripts/test-summary.sh npx jest src/foo.test.ts
bash scripts/test-summary.sh pytest tests/test_foo.py -q
```

The wrapper writes the full log to `.test-output/` and prints only a short
summary.

## Report

- Maximum 5 lines: status, counts if available, command, first failure, log path.
- Never paste raw test output or the full log.
- Details only when the user asks; read only the failing block from the log.

## Full suite

Only with an explicit user request or in CI.

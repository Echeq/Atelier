---
name: Hackathon Build
description: Use after an approved hackathon plan to execute the MVP DAG (Base + Requisitos) autonomously with per-task verification, stop on failure, and write docs/hackathon/BUILD.md. Works in any project without Atelier-specific agents.
---

# Hackathon Build

Phase 6 of `/hackathon build`.

Read `.opencode/skills/hackathon/RULES.md` first. It defines status,
build preconditions, failure and override.

## Preflight

Before executing any task, apply RULES.md "Build preconditions". If any check
fails, execute nothing and report the exact `BLOCKED:` reason. In particular:

- `PLAN.md` frontmatter is not exactly `Status: approved` ->
  `BLOCKED: PLAN.md not approved`.
- A `Base` or `Requisito` `F-xx` has no task ->
  `BLOCKED: F-xx <id> has no task`.
- A `Base` or `Requisito` task has no `F-xx` ->
  `BLOCKED: task <id> missing F-xx`.
- A `Base` or `Requisito` task has no non-empty `Verify` ->
  `BLOCKED: task <id> missing verify`.
- A task is `Mejora` or `Capricho` -> `BLOCKED: task <id> is post-MVP`.

Log the block in `LOG.md`.

## Execution

Apply RULES.md "Build execution". Execute only `Base` and `Requisito` tasks,
topologically by `Depends on`, one at a time. For each task:

1. Implement the smallest change that satisfies it.
2. Run the task's `Verify` exactly.
3. Append `TASK <id>: done` or `TASK <id>: failed` with the verification
   command and result to `LOG.md`.

Do not add features, abstractions, dependencies or files not required by the
task. Prefer the project's existing stack, scripts and conventions. Execute
the DAG yourself: do not delegate to Atelier subagents. Never require
Atelier-specific agents.

On failure: stop the DAG, append `BLOCKED: task <id> failed`, report the task,
verification, error and options. Do not claim the MVP is built.

## Completion

After all tasks pass:

1. Run the demo checklist from `PLAN.md`.
2. Write `docs/hackathon/BUILD.md`: status `built` or `demo-ready`, tasks and
   verification results, demo checklist result, known gaps and risks.
3. Set `PLAN.md` frontmatter to `Status: built`.
4. Append `BUILD: complete` to `LOG.md`.
5. Stop. Do not start `Mejoras` or `Caprichos` unless the user asks.

# Hackathon Rules

Shared source of truth for `/hackathon setup` and `/hackathon build`. Read this
file before any phase. If a skill or the command conflicts with this file, this
file wins.

## Communication

- Direct and short in free text. No filler, no restating the user.
- Tables and bullets over paragraphs.
- The conversation summary is at most 8 lines. This limit does not apply to the
  gate verification table.
- One question batch per phase. Details go in files, not chat.
- Reply in the user's language.

## Language

- Detect the user's language; use it for the intake and by default for the
  artifacts.
- Ask only on conflict: the user requests another language, the project
  convention requires one, or the conversation is mixed. If conflict, state it
  before writing: intake in X, artifacts in Y.
- Do not translate the tier names; use `Base`, `Requisito`, `Mejora`,
  `Capricho` (plural forms are allowed in prose).
- The command, the skills and this file are written in English.

## Files

- Create `docs/hackathon/` at the start, relative to the project root.
- Planning artifacts and logs:
  - `PRD-ANALYSIS.md` - source of truth for `REQ-xx`, `F-xx`, tiers and the
    REQ -> F mapping.
  - `PRD.md` - narrative: problem, user, non-goals, success criteria, demo.
  - `PLAN.md` - MVP plan and decision log, with frontmatter.
  - `LOG.md` - append-only events: sources read, unreadable files, question
    rounds, overrides, gate decisions, task results.
  - `BUILD.md` - build result and demo checklist status.
- `setup` writes nothing outside `docs/hackathon/`.
- `build` writes application code only where the approved task requires; it
  does not copy the project into `docs/hackathon/`.
- Read the user's source docs wherever they are.

## Source of truth

- `PRD-ANALYSIS.md` is the single source of truth for `REQ-xx`, `F-xx`, tiers
  and the REQ -> F mapping.
- `PRD.md` is narrative only. It references `PRD-ANALYSIS.md` and does not
  repeat the requirements table or tiers.
- If the two disagree, `PRD-ANALYSIS.md` wins.

## Tier definitions (literal, do not reinterpret)

- **Base**: without this `F-xx`, the demoable flow does not start. Not
  negotiable.
- **Requisito**: the brief explicitly asks for it in those words. If the brief
  does not say it, it is not a `Requisito`.
- **Mejora**: adds visible value, but the demo works without it. Goes to the
  cut list if time is tight.
- **Capricho**: the brief does not ask for it and it does not affect the demo.
  Removed by default; do not ask about it.

## Scope

- MVP = `Base + Requisitos`, complete, not a skeleton.
- `Mejoras` and `Caprichos` are post-MVP, only after the demo checklist passes.
- Hierarchy: `Base > Requisitos > Mejoras > Caprichos`.
- If a request breaks the hierarchy, judge it explicitly; do not silently
  comply.
- `Caprichos` are removed from the MVP by default and are not asked about.

## Status

- `PLAN.md` starts with YAML frontmatter:

  ```
  ---
  Status: draft
  ---
  ```

- `hackathon-mvp-planner` writes the initial `Status: draft`.
- `hackathon-gate` is the only writer of `approved`. It changes the value to
  `Status: approved` only when the user replies exactly `approve`. It never
  writes `approved` on `edit` or `stop`.
- `hackathon-build` accepts only the exact, case-sensitive frontmatter value
  `Status: approved`. A plain-text status line outside frontmatter, `status:
  approved`, `Status: Approved`, or any other variant is invalid.
- If the frontmatter is missing or not exactly `Status: approved`, build stops
  with `BLOCKED: PLAN.md not approved` and executes nothing.
- After a successful build, set the frontmatter to `Status: built`.

## Skill preflight

- Before the first phase, load every skill required by the subcommand.
- If a required skill is missing, has broken frontmatter, has the wrong ID or
  fails to load, stop immediately.
- Do not write any artifact.
- Report the phase, expected skill ID, expected path
  (`.opencode/skills/hackathon/<id>/SKILL.md`) and the failure.
- Before each phase, confirm its skill is loaded. If not, append
  `BLOCKED: missing skill <id>` to `LOG.md` and do not write that phase's
  artifacts or any later ones. Earlier artifacts stay as-is.

## Override

- Valid syntax: a user message starting with `override:` followed by the
  statement, for example: `override: F3 is Requisito, not Capricho`.
- Accept every override. Never reject one.
- Append to `LOG.md`: timestamp, exact statement, previous and new tier/scope,
  and a risk note if it breaks the demo or budget.
- Apply it to `PRD-ANALYSIS.md`, `PRD.md` and `PLAN.md` as needed.
- If ambiguous, ask one short clarifying question before applying.

## Gate checks

The gate table is complete and is never compressed to prose. Rows:

| Check | Result | Detail |
| --- | --- | --- |
| Over-engineering verdict | PASS/FAIL | `FAIL` if any MVP task lacks an `F-xx`, or if a `Mejora`/`Capricho` is scheduled in the MVP. |
| MVP functions without a task | PASS/FAIL | `F-xx` / `REQ-xx` not covered by the DAG. |
| Tasks without an `F-xx` | PASS/FAIL | Task IDs and the proposed removal. |
| MVP tasks without a non-empty `Verify` | PASS/FAIL | Task IDs and the missing verification. |
| Top 3 risks | - | One line each. |

- `MVP functions without a task` FAIL blocks approval.
- `Tasks without an F-xx` FAIL marks the task and proposes removal; it does not
  pass silently. The user must remove it or explicitly override.
- `MVP tasks without a non-empty Verify` FAIL blocks approval.
- On `approve`: set the `PLAN.md` frontmatter to `Status: approved`, append
  `GATE: approved` to `LOG.md`, and stop. Build only when the user asks in a
  new request.
- On `edit`: update files and repeat the gate. Do not write `approved`.
- On `stop`: leave files, append `GATE: stopped` to `LOG.md`, end. Do not write
  `approved`.

## Decision rules (the planner brain)

Apply to every requirement and implementation:

- Trace: brief, rubric or user must-have? If not, it is `Mejora` or
  `Capricho`.
- Simplify: smallest implementation; boring, proven choices; add a dependency
  only if it removes more work than it adds.
- Challenge: a `Capricho` or `Mejora` while `Base` or `Requisitos` are
  incomplete -> say it, offer to defer. Require `override:` if the user
  insists.
- Protect the demo: if it can be removed without breaking the demo, it is not
  MVP.
- Fit: does it fit time, team and stack with a buffer? If not, cut scope, not
  quality.

## Build preconditions

Before executing any task, `hackathon-build` verifies:

1. `PLAN.md` frontmatter is exactly `Status: approved`.
2. Every `Base` and `Requisito` `F-xx` has at least one task.
3. Every `Base` and `Requisito` task has a non-empty `F-xx`.
4. Every `Base` and `Requisito` task has a non-empty `Verify`.
5. No task in the DAG is `Mejora` or `Capricho`.

If any check fails, execute nothing and report:

- `BLOCKED: PLAN.md not approved`
- `BLOCKED: F-xx <id> has no task`
- `BLOCKED: task <id> missing F-xx`
- `BLOCKED: task <id> missing verify`
- `BLOCKED: task <id> is post-MVP`

Log the block in `LOG.md`.

## Build execution

- Execute only `Base` and `Requisito` tasks, topologically by `Depends on`.
- One task at a time; smallest change that satisfies it.
- Run the task's `Verify` exactly. No "looks done".
- Append `TASK <id>: done|failed` with the verification command and result to
  `LOG.md`.
- On failure: stop the DAG, append `BLOCKED: task <id> failed`, report the
  task, verification, error and options (fix, retry, revise). Do not claim the
  MVP is built.
- On retry: resume from the first failed or incomplete task; do not redo tasks
  logged as done.
- After all tasks: run the demo checklist, write `BUILD.md`, set `PLAN.md` to
  `Status: built`, append `BUILD: complete` to `LOG.md`.
- Do not start `Mejoras` or `Caprichos` unless the user asks.
- Prefer the project's existing stack, scripts and conventions.
- `hackathon-build` is autonomous: the current `build` session executes the
  DAG itself. Do not delegate to Atelier subagents.
- Never require Atelier-specific `planner`, `worker` or `evaluator-optimizer`
  agents; the pipeline must work without them.

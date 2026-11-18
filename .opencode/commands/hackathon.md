---
description: Hackathon pipeline - setup (plan) and build (execute an approved plan), with docs/hackathon artifacts.
agent: build
---

# /hackathon

Portable hackathon pipeline for any project. `setup` plans; `build` executes an
approved plan. Shared rules live in
`.opencode/skills/hackathon/RULES.md` and are authoritative.

Argument: `$ARGUMENTS`

## Routing

- `setup`: plan. Intake, PRD Transformer, PRD, PLAN and the approval gate.
- `build`: execute an approved `docs/hackathon/PLAN.md`.
- empty or unknown: print `/hackathon setup` and `/hackathon build` and stop.

## Shared rules

Read `.opencode/skills/hackathon/RULES.md` before any phase. It defines
tiers, source of truth, status, override, language, files, communication, gate
checks, build preconditions and failure handling.

If a skill conflicts with `RULES.md`, `RULES.md` wins. The command only adds
routing and phase order.

## Skills

Preflight for the requested subcommand:

- `setup`: `hackathon-intake`, `hackathon-prd-transformer`,
  `hackathon-mvp-planner`, `hackathon-gate`.
- `build`: `hackathon-build`.

Load them before Phase 0 (`setup`) or Phase 6 (`build`). If any required skill
is missing, has broken frontmatter, wrong ID or fails to load, stop immediately
and report the phase, expected ID, expected path
(`.opencode/skills/hackathon/<id>/SKILL.md`) and the failure. Do not
write any artifact. See `RULES.md` "Skill preflight".

## Pipeline

`setup`:

1. `hackathon-intake` - Phase 0-1.
2. `hackathon-prd-transformer` - Phase 2.
3. `hackathon-mvp-planner` - Phase 3-4.
4. `hackathon-gate` - Phase 5.

`build`:

1. `hackathon-build` - Phase 6.

Do not skip a phase. Before each phase, confirm its skill is loaded; if not,
stop, append `BLOCKED: missing skill <id>` to `docs/hackathon/LOG.md`, and do
not write that phase's artifacts or any later ones. Earlier artifacts stay.

## Output

- `docs/hackathon/PRD-ANALYSIS.md`
- `docs/hackathon/PRD.md`
- `docs/hackathon/PLAN.md`
- `docs/hackathon/LOG.md`
- `docs/hackathon/BUILD.md` (`build` only)
- Short chat summary and the gate table (`setup`) or build report (`build`).

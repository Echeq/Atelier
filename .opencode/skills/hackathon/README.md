# Hackathon skills

Project skills for `/hackathon setup` and `/hackathon build`, grouped under
`.opencode/skills/hackathon/`.

`RULES.md` is the shared source of truth. Every skill reads it first; if a
skill conflicts with it, `RULES.md` wins.

| Skill ID | Phase | Purpose |
| --- | --- | --- |
| `hackathon-intake` | 0-1 | Intake batch, language detection, document scan, unreadable-file fallback. |
| `hackathon-prd-transformer` | 2 | REQ -> What/How/When -> F-xx, tier classification, `PRD-ANALYSIS.md`. |
| `hackathon-mvp-planner` | 3-4 | `PRD.md` narrative and `PLAN.md` with F-xx DAG, decision log, cut list. |
| `hackathon-gate` | 5 | Approval gate table, inverse trace check, over-engineering verdict, `Status: approved`. |
| `hackathon-build` | 6 | Execute an approved `PLAN.md` autonomously: Base + Requisitos only, per-task Verify, stop on failure, `BUILD.md`. |

Load order is top to bottom. `PRD-ANALYSIS.md` is the single source of truth
for requirements, functions and tiers.

To use the pipeline in another project, copy
`.opencode/commands/hackathon.md` and `.opencode/skills/hackathon/` into that
project's `.opencode/`, or into `~/.config/opencode/` for a global install.

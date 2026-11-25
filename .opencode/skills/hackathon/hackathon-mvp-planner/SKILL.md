---
name: Hackathon MVP Planner
description: "Use to turn docs/hackathon/PRD-ANALYSIS.md into a realistic MVP: PRD narrative, milestones with buffer, task DAG traced to F-xx, decision log, cut list, and post-MVP backlog."
---

# Hackathon MVP Planner

Phase 3-4 of `/hackathon setup`.

Read `.opencode/skills/hackathon/RULES.md` first. It defines scope,
tiers, status, decision rules and files.

## PRD.md (narrative only)

Write `docs/hackathon/PRD.md` with:

1. Problem, target user, goal.
2. Non-goals.
3. MVP scope: reference `PRD-ANALYSIS.md` for `Base + Requisitos`; do not
   repeat the table.
4. Success criteria and demo script.
5. Constraints, risks, assumptions, open questions.

Every success criterion is observable. Do not duplicate requirements or tiers.

## PLAN.md

Write `docs/hackathon/PLAN.md` starting with:

```
---
Status: draft
---
```

Then:

1. MVP boundary: one end-to-end flow, `Base + Requisitos` only.
2. Architecture: smallest components and data flow.
3. Milestones with an integration and demo buffer (about 20%).
4. Task DAG:
   `ID | Task | F-xx | Tier | Depends on | Estimate | Deliverable | Verify`.
   Every task references one `F-xx`; no orphan tasks.
5. Decision log: `Request | Tier | Verdict | Why | Simplest path`
   (`accept`, `defer`, `reject`, `override`).
6. Demo checklist, cut list, top 3 risks, post-MVP backlog.

Apply RULES.md "Decision rules". If it does not fit the budget, cut scope, not
quality. Never cut a `Requisito` without explicit approval. No task without
verification. `Mejoras` first in the post-MVP backlog; `Caprichos` only if the
user asks.

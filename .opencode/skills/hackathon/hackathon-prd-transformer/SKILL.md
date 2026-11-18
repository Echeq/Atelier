---
name: Hackathon PRD Transformer
description: Use to transform hackathon requirements into end-to-end functions with a What/How/When analysis, assign Base/Requisito/Mejora/Capricho tiers, and write docs/hackathon/PRD-ANALYSIS.md.
---

# Hackathon PRD Transformer

Phase 2 of `/hackathon setup`.

Read `.opencode/skills/hackathon/RULES.md` first. It defines the tier
definitions, source of truth, override and language rules.

## Procedure

For every atomic requirement from the brief, rubric or user:

1. Give it `REQ-xx` and a source.
2. Project it on three axes:
   - **What**: what must exist? Input, output, observable behavior, minimum
     scope.
   - **How**: simplest mechanism (UI, data, API, integration), dependencies,
     failure points.
   - **When**: trigger, sequence, milestone or deadline, demo moment.
3. Unknown answer -> `OPEN-xx`; ask only these, in one batch.
4. Derive the smallest set of end-to-end functions (`F-xx`) that makes the
   product work. Each function traces to at least one `REQ-xx`.
5. Tier each function using RULES.md "Tier definitions". A function that is
   neither `Base` nor `Requisito` is `Mejora` or `Capricho` and does not enter
   the MVP. Remove `Caprichos` from the MVP by default; do not ask about them.
6. Record the tier rationale next to each `F-xx`.

## Output

Write `docs/hackathon/PRD-ANALYSIS.md` with:

- `REQ | Source | What | How | When | Function | Tier | Why this tier | OPEN`
- `Function | Covers | Demo moment | Verification`

Every explicit hackathon requirement is `Base` or `Requisito`. Keep tier names
verbatim. `PRD.md` is narrative only; if the two disagree,
`PRD-ANALYSIS.md` wins.

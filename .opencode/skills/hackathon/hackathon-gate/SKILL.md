---
name: Hackathon Gate
description: "Use to run the hackathon approval gate: verify every MVP function has a task, every DAG task traces to an F-xx and has a Verify, flag over-engineering, show risks, and handle approve/edit/stop."
---

# Hackathon Gate

Phase 5 of `/hackathon setup`.

Read `.opencode/skills/hackathon/RULES.md` first. It defines the status
mechanism, gate checks, override and communication rules.

## Output: two blocks

**Conversation summary (max 8 lines):** the four paths, the MVP flow in one
line, tier counts.

**Gate table (complete, never compressed to prose):**

| Check | Result | Detail |
| --- | --- | --- |
| Over-engineering verdict | PASS/FAIL | `FAIL` if any MVP task lacks an `F-xx`, or if a `Mejora`/`Capricho` is scheduled in the MVP. List the offenders. |
| MVP functions without a task | PASS/FAIL | `F-xx` / `REQ-xx` not covered by the DAG. |
| Tasks without an `F-xx` | PASS/FAIL | Task IDs and the proposed removal. |
| MVP tasks without a non-empty `Verify` | PASS/FAIL | Task IDs and the missing verification. |
| Top 3 risks | - | One line each. |

Apply RULES.md "Gate checks" for blocking and resolution.

## Approve / edit / stop

- Ask: `approve`, `edit <what>`, `stop`.
- On `approve`: rewrite the `PLAN.md` frontmatter to `Status: approved`, append
  `GATE: approved` to `LOG.md`, and stop. This is the only place that writes
  `approved`.
- On `edit`: update the artifacts and repeat the gate. Do not write `approved`.
- On `stop`: leave the files, append `GATE: stopped` to `LOG.md`, end. Do not
  write `approved`.
- Build only when the user asks in a new request; `approve` does not start the
  build.

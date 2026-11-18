---
name: Hackathon Intake
description: Use at the start of a hackathon plan to ask the intake batch, detect the user's language, scan the requirements folder, and report unreadable DOCX/PDF files with actionable options.
---

# Hackathon Intake

Phase 0-1 of `/hackathon setup`.

Read `.opencode/skills/hackathon/RULES.md` first. It is authoritative
for language, files, communication and skill failure.

## Phase 0 - Intake

Ask one short batch:

1. Hackathon/track and the product goal in one sentence.
2. Time budget, team size and roles.
3. Stack, hosting and demo constraints.
4. Judging criteria and demo format.
5. Requirements folder to scan, or `none`.
6. Existing PRD/brief path, or `none`.

Confirm paths exist. Apply RULES.md "Language" for the intake and artifact
language. Do not ask about artifact language unless there is a conflict.

## Phase 1 - Read

1. Glob the folder for `**/*.md`, `**/*.txt`, `**/*.pdf`, `**/*.docx`,
   `**/*.json`, `**/*.yaml`, `**/*.yml`.
2. Skip `.git/`, `node_modules/`, `.venv/`, `dist/`, `build/`, `cache/`,
   `.next/`.
3. Prefer `README*`, `PRD*`, `BRIEF*`, `RULES*`, `SPEC*`, `docs/**`.
4. If a `.docx` is unreadable as text, or a `.pdf` has no text layer, tell the
   user in their language: "Could not read `<file>` as text. Export it to a
   text-selectable PDF, paste the requirements and judging-criteria sections,
   or say to ignore it."
5. Record every unreadable source in `docs/hackathon/LOG.md` as
   `OPEN: unreadable source <file>`. Do not guess.
6. If nothing is found, say so and continue.

## Output

- Short intake summary: goal, time, team, stack, demo, judging criteria.
- Sources read and `OPEN:` items.
- Append events to `docs/hackathon/LOG.md`.
- Do not classify tiers. Hand off to `hackathon-prd-transformer`.

# AGENTS.md

## Project

Atelier is an OpenCode V2 project scaffold: configuration only, no application
code. There is nothing to build, test, or lint — do not hunt for tooling.

## Hard rule: everything lives in this repository

All configuration, agents, commands, and docs live inside this project folder.
No dependency on files, agents, or config outside it (no global
`~/.config/opencode` requirements). It must work standalone after a clone.

## Layout

- `opencode.json` — project default model and `default_agent`.
- `.opencode/agents/` — one file per agent; each file is the source of truth
  for that agent's contract and JSON schema. `atelier.md` is the primary/default
  supervisor; `planner.md`, `worker.md`, and `evaluator-optimizer.md` are the
  subagents.
- `.opencode/commands/{setup,smoke,hackathon}.md` — `/setup` init, `/smoke`
  pipeline test, `/hackathon` plan/build pipeline.
- `.opencode/skills/ai-docs/` — GitHub docs standard (`SKILL.md`,
  `README-TEMPLATE.md`).
- `.opencode/skills/hackathon/` — shared `RULES.md` plus five skills:
  `hackathon-intake`, `hackathon-prd-transformer`, `hackathon-mvp-planner`,
  `hackathon-gate`, `hackathon-build`.
- `scripts/test-summary.sh` — test wrapper that keeps full logs out of the
  conversation.
- `.opencode/skills/verification/` — test output and targeted-verification rules.
- `README.md` — user-facing docs and installation.

## Config and pipeline behavior

- OpenCode V2 reloads `opencode.json`, agents, commands, and skills
  automatically; run `opencode reload` only if a change does not appear.
- `tool_output` caps tool results to 120 lines / 16 KiB. Tests run through
  `scripts/test-summary.sh`; the full log stays in `.test-output/`, and the
  `verification` skill forbids dumping raw test output.
- `opencode.json` sets model `opencode-go/deepseek-v4.1-flash` and
  `default_agent: "atelier"`. Agents without a `model:` frontmatter field
  inherit the project default; pin one with `model: provider/model-id` or a
  variant with `model: provider/model-id#variant`.
- No `subagent_depth` is configured. The default depth is 1: `atelier` launches
  `planner`, `worker`, and `evaluator-optimizer`; none of them launches another
  subagent. Do not reintroduce a nested orchestrator or the experimental
  `experimental.subagent_depth` flag.
- Agent frontmatter uses the native V2 shape: `permissions` (ordered rules with
  `action`, `resource`, `effect`) and `steps`. Do not reintroduce V1 fields
  (`permission`, `bash`, `task`, `temperature`, `maxSteps`, `tools`): a file
  that uses `permissions` is read as V2 and its V1 fields are ignored.
- `atelier` executes planner DAGs itself: it validates the graph, dispatches
  independent workers in parallel, retries a failed subtask once, cascades
  dependents to `skipped`, and runs the evaluator gate only on the final
  aggregate. Keep DAGs to roughly 12 subtasks or fewer.
- Subagents run in background child sessions. A `subagent` call returns a
  `sessionID` immediately; the result arrives later as a `<subagent>` message.
  Never treat the call's return value as the subtask result.
- `/setup` verifies the four agent files and rewrites `opencode.json` with
  `$schema`, `model`, and `default_agent` (asks before overwrite).
- `/smoke` exercises planner → worker → evaluator and validates the three JSON
  contracts; structural, not deterministic, several calls.
- `/hackathon setup` plans a hackathon or rapid project: intake, PRD
  Transformer, PRD, MVP plan, and approval gate. `/hackathon build` executes the
  approved `docs/hackathon/PLAN.md` autonomously (Base + Requisitos only,
  per-task Verify) and writes `docs/hackathon/BUILD.md`.
- Planner/worker/evaluator contracts are frozen at v1: do not add, rename, or
  remove fields; report mismatches instead.

## Routing

All subagents are invoked with the `subagent` tool (`agent`, `description`,
`prompt`) and return strict JSON (no fences, no prose). `atelier` is the only
interactive agent (`question` allowed, `edit`/`shell` denied: never hand it
deliverable work); subagents cannot ask questions, so resolve ambiguity before
dispatching. `worker` allows `edit`/`shell`; planner and evaluator-optimizer
never touch the filesystem.

- Trivial or conversational request → answer directly; no pipeline.
- Single deliverable → `worker` with a self-contained prompt: `SUBTASK_ID`
  (optional), `TASK`, `INPUTS`, `EXPECTED_OUTPUT`.
- Multi-deliverable → `planner` (`TASK`, optional `CONTEXT`/`CONSTRAINTS`), then
  `atelier` executes the DAG itself. If the planner returns
  `needs_clarification=true` (empty subtasks), resolve its questions with the
  user and re-invoke with richer context.
- Quality-critical single delivery → `evaluator-optimizer` with `TASK`,
  `RESULT`, optional `CRITERIA`. DAGs already get `atelier`'s final gate — do
  not duplicate it.

## Gotchas

- Subagents are asynchronous; a dispatched worker reports back in a later
  message. Plan the supervisor's turns around that, not around a blocking call.
- `/smoke` is structural and consumes several model calls per run.
- The hackathon skills are advertised to every session. Keep their descriptions
  precise; the `/hackathon` command loads them by ID.
- Global install requires all four agent files, not just `atelier.md`, which
  dispatches to the others.
- Never paste raw test output. Report status, counts, command, first failure,
  and the log path; read only the failing block when more detail is needed.

## Conventions

- All `.md` files in this repository are written in English.
- GitHub-facing docs follow the ai-docs skill
  (`.opencode/skills/ai-docs/SKILL.md`): no empty or placeholder sections,
  optional sections commented until they have real content, badges only when
  the claim is true, small legible Mermaid diagrams.

# AGENTS.md

## Project

Atelier is an OpenCode project scaffold: configuration only, no application
code. There is nothing to build, test, or lint — do not hunt for tooling.

## Hard rule: everything lives in this repository

All configuration, agents, commands, and docs live inside this project folder.
No dependency on files, agents, or config outside it (no global
`~/.config/opencode` requirements). It must work standalone after a clone.

## Layout

- `opencode.json` — project default model, `subagent_depth`, `default_agent`.
- `.opencode/agents/` — one file per agent; each file is the source of truth
  for that agent's contract and JSON schema. `atelier.md` is the
  primary/default supervisor; `planner.md`, `orchestrator.md`, `worker.md`,
  `evaluator-optimizer.md` are the subagents.
- `.opencode/command/{setup,smoke}.md` — `/setup` init and `/smoke` pipeline test.
- `.opencode/skills/ai-docs/` — GitHub docs standard (`SKILL.md`,
  `README-TEMPLATE.md`).
- `README.md` — user-facing docs and installation.

## Config and pipeline behavior

- opencode loads config once at startup: restart after changing
  `opencode.json`, agents, commands, or skills.
- `opencode.json` currently sets model `opencode-go/deepseek-v4.1-flash`,
  `subagent_depth: 2`, `default_agent: "atelier"`. Agents without a `model:`
  frontmatter field inherit the project default; pin one with
  `model: provider/model-id`.
- `subagent_depth` default is 1. The planner → orchestrator → worker pipeline
  needs at least 2 (currently 2); with 1, nested dispatch fails. Values above
  1 multiply model/token consumption: each orchestrator run spawns multiple
  worker calls plus the final evaluation gate.
- `/setup` verifies the pipeline agent files exist and rewrites `opencode.json`
  with only `$schema`, `model`, `subagent_depth` (asks before overwrite). It
  does not write `default_agent` — restore `"default_agent": "atelier"` after
  running it.
- `/smoke` (after an opencode restart) exercises planner → orchestrator and
  validates both JSON contracts; structural, not deterministic, several calls.
- The planner is pure overhead for a single-step task. The orchestrator
  executes the given DAG exactly and never re-plans; one retry per failed
  subtask, then dependents cascade to `skipped` while independent branches
  continue; the evaluator gate runs only on the final aggregate. Keep DAGs to
  roughly 12 subtasks or fewer to avoid context exhaustion.
- Planner/orchestrator/worker/evaluator contracts are frozen at v1: do not
  add, rename, or remove fields; report mismatches instead.

## Routing

All subagents are invoked via the Task tool with `subagent_type` and return
strict JSON (no fences, no prose). `atelier` is the only interactive agent
(`task`/`question` allowed, `edit`/`bash` denied: never hand it deliverable
work); subagents cannot ask questions, so resolve ambiguity before dispatching.
`worker` allows `edit`/`bash`; planner, orchestrator, and evaluator-optimizer
never touch the filesystem.

- Trivial or conversational request → answer directly; no pipeline.
- Single deliverable → `worker` with a self-contained prompt: `SUBTASK_ID`
  (optional), `TASK`, `INPUTS`, `EXPECTED_OUTPUT`.
- Multi-deliverable → `planner` (`TASK`, optional `CONTEXT`/`CONSTRAINTS`),
  then pass its plan verbatim to `orchestrator` with
  `AVAILABLE_AGENTS: worker, evaluator-optimizer`. If the planner returns
  `needs_clarification=true` (empty subtasks), resolve its questions with the
  user and re-invoke with richer context.
- Quality-critical single delivery → `evaluator-optimizer` with `TASK`,
  `RESULT`, optional `CRITERIA`. DAGs already get the orchestrator's final
  gate — do not duplicate it.

## Gotchas

- `.opencode/.gitignore` ignores `node_modules`, `package.json`, `bun.lock`,
  `package-lock.json` and itself (opencode-managed; no git visibility).
- `.opencode/node_modules/` is opencode's plugin dependency tree (declared in
  `.opencode/package.json`); exclude it from glob/grep to avoid noise.
- Global install (README): copy ALL five agent `.md` files — not just
  `atelier.md`, which dispatches to the others — plus optionally the ai-docs
  skill, and set `default_agent: "atelier"` in the global config.

## Conventions

- All `.md` files in this repository are written in English.
- GitHub-facing docs follow the ai-docs skill
  (`.opencode/skills/ai-docs/SKILL.md`): no empty or placeholder sections,
  optional sections commented until they have real content, badges only when
  the claim is true, small legible Mermaid diagrams.

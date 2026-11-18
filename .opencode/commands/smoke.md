---
description: Smoke test for the agent pipeline — runs planner, worker and evaluator on a synthetic task and validates their JSON contracts. Run after changing agents.
agent: build
---

Run the pipeline smoke test. Execute the steps exactly, then report a PASS/FAIL
table. Never fix or edit outputs — report failures with the raw JSON. Every
`subagent` call needs `agent`, a short `description`, and `prompt`.

1. Verify these files exist (Read or Glob):
   - `.opencode/agents/atelier.md`
   - `.opencode/agents/planner.md`
   - `.opencode/agents/worker.md`
   - `.opencode/agents/evaluator-optimizer.md`
   If any is missing, report FAIL and stop.

2. Invoke the planner subagent with the `subagent` tool (`agent: "planner"`)
   and exactly:
   TASK: Write a two-line story about a lighthouse (t1). Translate that story to Spanish (t2, depends on t1). Count the words in the original story (t3, depends on t1).
   Do not add CONTEXT or CONSTRAINTS. Wait for its `<subagent>` report before
   continuing.

3. Parse the planner report as strict JSON and check each item:
   - parses, with no surrounding prose or fences
   - schema_version == "1"
   - needs_clarification == false and subtasks is a non-empty list
   - ids unique; every depends_on references an existing id; acyclic
   - every subtask has non-empty title, description, and expected_output
   Record PASS/FAIL per check; on FAIL, show the raw output.

4. Invoke the worker subagent with the `subagent` tool (`agent: "worker"`) and
   this self-contained prompt:
   SUBTASK_ID: t1
   TASK: Write a two-line story about a lighthouse.
   INPUTS: none
   EXPECTED_OUTPUT: A two-line story about a lighthouse.
   Wait for its `<subagent>` report before continuing.

5. Parse the worker report as strict JSON and check each item:
   - parses, with no surrounding prose or fences
   - schema_version == "1"
   - status in completed|failed|blocked
   - when completed: subtask_id == "t1", non-empty output, empty error
   - confidence is a number between 0.0 and 1.0
   Record PASS/FAIL per check; on FAIL, show the raw output.

6. Invoke the evaluator-optimizer subagent with the `subagent` tool
   (`agent: "evaluator-optimizer"`) and:
   TASK: Write a two-line story about a lighthouse.
   RESULT: <the worker output verbatim>
   CRITERIA: two lines; about a lighthouse.
   Wait for its `<subagent>` report before continuing.

7. Parse the evaluator report as strict JSON and check each item:
   - parses, with no surrounding prose or fences
   - passed is a boolean; score and confidence are numbers between 0.0 and 1.0
   - result is non-empty
   - when passed == true: changes is empty
   Record PASS/FAIL per check; on FAIL, show the raw output.

8. Report: compact table (check -> PASS/FAIL) and an overall PASS only if all
   checks pass. State that each run consumes several model calls and that the
   smoke test is structural, not deterministic.

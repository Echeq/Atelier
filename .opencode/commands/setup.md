---
description: Interactive init — picks the project default model and writes opencode.json with the Atelier defaults.
agent: build
---

You are the interactive project setup for Atelier. Follow these steps exactly.

1. Check if `opencode.json` exists in the project root.
   - If it exists, ask with the question tool: "⚠️ opencode.json already
     exists. Overwrite it?" Options: "Continue" and "Cancel". Stop on Cancel.
2. Verify these files exist (Read or Glob):
   - `.opencode/agents/atelier.md`
   - `.opencode/agents/planner.md`
   - `.opencode/agents/worker.md`
   - `.opencode/agents/evaluator-optimizer.md`
   - `.opencode/agents/ideator.md`
   - `.opencode/agents/solver.md`
   If any is missing, list the missing paths and stop.
3. Build the model options from live data, never from hardcoded IDs:
   - Run `opencode models` and use its output.
   - Recommended: the provider ID and model ID from your own system prompt,
     which is guaranteed available. If absent, use the first model listed.
   - Offer up to two other models from the list that fit the user's setup.
   - Always include a Custom option for a free-form model ID.
4. Ask one question (question tool) for the project default model.
5. Write `opencode.json` in the project root with exactly:
   {
     "$schema": "https://opencode.ai/config.json",
     "model": "<chosen model ID>",
     "default_agent": "atelier"
   }
   Do not add `subagent_depth` or any nesting field: Atelier uses the default
   depth of 1 and launches its subagents directly.
6. Read the file back and parse it. If parsing fails, fix it before continuing.
7. Confirm: "Atelier is ready. Default model: <id>. OpenCode reloads this
   automatically; run `opencode reload` only if needed. Run /smoke to verify the
   agent pipeline."

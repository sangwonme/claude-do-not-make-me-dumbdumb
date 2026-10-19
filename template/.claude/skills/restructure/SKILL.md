---
name: restructure
description: Change the code's structure or framework without changing what it does, after the developer decided to (a /reflect decision, or a reviewer's reframe they accepted). Maps old code to the developer's target structure, ports Test/, deletes what is left behind, and proves behavior held against a test baseline.
disable-model-invocation: true
argument-hint: "[decision file | QA report finding]"
---

# Restructure

Request: $ARGUMENTS

Load ponytail (`.claude/skills/ponytail/SKILL.md`) for every step. **The developer chooses the target; you move the code.** Behavior must not change: no new features, no fixes riding along.

1. **Why**: the given decision in `Docs/Decisions/` or QA finding, else the newest decision whose Decision is "Change framework" or whose Reviewer points accept a reframe. None → ask what to restructure and why, and stop if the developer has not decided to.
2. **Target, in the developer's words**:
   - Framework change: the spec's §6 must already name the new stack, run, and test commands. If it still names the old ones, stop and tell the developer to update §6 (or run `/spec refine`).
   - Structure reframe: ask in one AskUserQuestion what the target structure is and which §4 core-logic steps each part holds. Offer the reviewer's suggestion verbatim as one option, never your own. If the reframe changes how the developer explains §4, they edit §4 themselves first.
3. **Baseline**: run the app and `Test/` with the *current* commands. Record which tests pass. A test failing now is not your job to fix here; note it.
4. **Map**, shown in chat and approved by the developer before any edit (one AskUserQuestion: approve / edit):
   - every §4 step → old `file:line` → new location
   - every `Test/` file → kept as is, or ported (new runner, same scenario ID, same asserted Then)
   - every old file → moved, merged, or deleted
   - new dependencies, if any (framework change only). Install nothing without this approval.
5. **Move**: carry the code to the new structure or stack. Delete old files and dependencies the map retires; nothing old stays behind "just in case". For a new test runner or E2E tool, follow `.claude/skills/qa/e2e.md`.
6. **Prove**: run the app and `Test/` with §6's commands. Every test that passed at baseline passes now. Then self-review with `.claude/skills/ponytail-review/SKILL.md` (functions named after a §4 step stay, see `CLAUDE.md`).
7. **Report**: the map as done, `baseline: N passed → after: N passed`, deleted files, and anything that could not move. Suggest `/qa code` so the reviewers can check the new shape.

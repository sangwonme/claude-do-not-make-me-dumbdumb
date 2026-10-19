---
name: poc
description: Isolated core-logic experiments in PoC/<name>/. "/poc new <name>" interviews the developer for the question, prediction, and merge criteria. "/poc run <name>" builds and runs the smallest experiment in the shared container and records facts. "/poc merge <name>" moves a PoC the developer decided to keep into Codes/, test-first. "/poc drop <name>" freezes it and removes its dependencies.
disable-model-invocation: true
argument-hint: "new <name> | run <name> | merge <name> | drop <name>"
---

# PoC

Arguments: $ARGUMENTS. First word is the mode; no mode → ask. `<name>` is kebab-case. The rules in `CLAUDE.md` (PoC, Environment, Developer docs) apply to every mode.

`PoC/<name>/README.md` is the developer's (question, prediction, conclusion). `PoC/<name>/result.md` is yours: facts per run, append only.

## new <name>

1. `PoC/<name>/` must not exist; if it does, show its README and stop.
2. If a spec exists, read §4 Core logic and §9 Open questions so you can offer the developer's own words as options.
3. Interview in one AskUserQuestion call, open questions:
   - **Question**: what this experiment answers. Options: §4 steps and §9 questions, quoted.
   - **Prediction**: what result you expect, and why.
   - **Observe**: what output, number, or behavior will show it.
   - **Merge if / Drop if**: what result means it goes into `Codes/`, and what means it doesn't.
   Vague answer → ask again about that answer only.
4. Create `PoC/<name>/README.md` from `template.md` (next to this file), answers verbatim.
5. Report the path. Next: `/poc run <name>`.

## run <name>

0. Load ponytail at **ultra**.
1. README must have Question, Prediction (with why), Observe, and Merge if / Drop if. Missing → list them and stop. Never fill them in.
2. §6 Container empty → set it up with `.claude/guides/environment.md` first.
3. **Build** inside `PoC/<name>/` only, fewest files, plus one check that prints or asserts what Observe names. Needs `Codes/` logic → a stand-in with fixtures, as `CLAUDE.md` says. Needs a new dependency → ask, add it to `Dockerfile` as a `# poc: <name>` line, rebuild.
4. **Run** with the PoC prefix from §6 Container. Not done while it errors.
5. Append to `PoC/<name>/result.md`: date, commit (if git), command, dependencies added, stand-ins used (`Codes/` path and fixture source), raw output, and `| Prediction (yours) | Observed |`. No judgment.
6. Report the table. Then: "Write your Conclusion in `PoC/<name>/README.md` (merge, drop, or run again with what change), or `/reflect` on it."

## merge <name>

1. **Decided?** The README's Conclusion, or a `Docs/Decisions/` file, must say merge. Otherwise stop and say so.
2. **Where it belongs**: ask which §5 scenarios and which §4 step this PoC's logic serves, offering IDs and step names. If no scenario fits, stop: the developer adds one to the spec first.
3. **Baseline**: run `Codes/Test/` with §6 Test. Record what passes.
4. **Map**, approved before any edit (one AskUserQuestion: approve / edit):
   - PoC `file:line` → §4 step → `Codes/` location
   - each stand-in → the real `Codes/` call it replaces, plus a contract test that the real function matches its fixture
   - the PoC's check → scenario tests in `Codes/Test/` (the developer approves the cases, as in `/qa` step 3.1)
   - each `# poc: <name>` line in `Dockerfile` → moved into the `Codes/` manifest, or removed
5. **Tests first**: write the approved scenario and contract tests in `Codes/Test/`. Run; scenario tests fail for the right reason.
6. **Build** in `Codes/` at ponytail **full** until they pass, and every baseline test still passes. Self-review with `.claude/skills/ponytail-review/SKILL.md` (§4 step functions stay, see `CLAUDE.md`). Rebuild the image if dependencies moved.
7. **Freeze**: append to `result.md`: `Merged into <Codes/ paths> on <date> (<commit>).` Never edit the PoC again.
8. Report: the map as done, `baseline: N passed → after: N passed`, new tests. Suggest `/qa`.

## drop <name>

1. The README's Conclusion or a decision must say drop. Otherwise stop.
2. Show its `# poc: <name>` lines in `Dockerfile` and ask to remove them; rebuild.
3. Append to `result.md`: `Dropped on <date>.` Keep the folder as a record; never edit it again.

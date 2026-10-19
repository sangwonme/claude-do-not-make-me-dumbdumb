---
name: prototype
description: Build the smallest working version of scenarios from the developer's spec, test-first (approved scenario tests in Codes/Test/ go red, then green), run it, and report observed results next to the developer's predictions, then cut it down with a ponytail-review self-check. Use when the user asks to build or try a scenario or idea, or types "/prototype [scenario IDs or idea]".
argument-hint: "[scenario IDs | idea]"
---

# Prototype

Request: $ARGUMENTS

0. **Load ponytail**: read `.claude/skills/ponytail/SKILL.md` and apply it at the current level (full unless the user changed it) for every step below.
1. **Predictions first**: the developer's predictions are the spec's scenarios. Do not build until they exist.
   - Find the spec in `Docs/Spec/`. No spec → tell the user to run `/spec setup` and stop.
   - Pick the scenarios: the IDs given, else those whose names match the request, else the first-prototype scope in §7. Unsure → ask which scenarios, offering their IDs and names.
   - Each picked scenario needs a concrete Given, one When, an observable Then, and "Why I expect this". Framework (§6) needs at least Stack, Run, and Source root. If anything is missing, list exactly what and stop. Never fill it in or guess it.
   - Restate in chat, one line per scenario: `S1: expecting <Then>.`
2. **Tests first (red)**: for picked scenarios without a test in `Codes/Test/`, follow steps 3.1-3.2 of `.claude/skills/qa/SKILL.md` (the developer approves the cases, then you write them). Run them and confirm they fail for the right reason. §6 Container or Test missing → set it up with the developer using `.claude/guides/environment.md`. Every command runs through the §6 Container prefix.
3. **Build (green)**: in `Codes/`, never in `PoC/`. The core logic (§4) in as few files as possible, readable in one place, in the stack and source root from §6, until the picked scenarios' tests pass. Never change a test to make it pass. Values the spec does not give: pick a default, list it under `tune` in the report, and never write it into the spec.
4. **Run**: start the app with §6 Run. Not done while it errors. Then perform each picked scenario's When, the way §6 Operate says, and record what was observed. If you cannot operate it, ask the developer to do the When and tell you what happened.
5. **Self-review**: read `.claude/skills/ponytail-review/SKILL.md` and review every file you created or changed against it. Apply every cut that keeps the tests green, then repeat step 4. If nothing can be cut, move on.
6. **Report**:
   ```
   | Scenario | Expected (yours) | Test | Observed |
   built: X. tune: <values worth tweaking>. cut in review: <what, or "nothing">. skipped: Y, add when Z.
   ```
   Do not judge whether the prediction held or what it means. End with: "What does this tell you? `/qa` to check it properly, `/reflect` to write down what you learned."

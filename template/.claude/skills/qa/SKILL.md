---
name: qa
description: QA a defined part of the app with two teams. Testing team writes and runs scenario tests in Test/ (TDD). Reviewer team (core reviewers plus the spec's stakeholder personas) each use the app their own way while logs and captures are collected, then each reviews the code and their own session independently. Writes QA/{date}-{title}.md. Always agrees on scope and purpose with the user first.
disable-model-invocation: true
argument-hint: "[test | code | use] [what to test]"
---

# QA

Request: $ARGUMENTS

If the first word is `test`, `code`, or `use`, run only that part (with steps 1 and 2); otherwise run all three: **test → code review → use review**.

Dates are `YYYY-MM-DD` (today). `{title}` is a short kebab-case name for the scope. If the report already exists, append `-2`, `-3`, ... `{run}` is `QA/{date}-{title}/`. Write evidence and the report in the spec's language (no spec: the user's language). Read the spec first; §6 Framework says how to run, test, and operate the app.

## 1. Agree on scope and purpose (required)

Do not start until all of these have clear answers. Ask in one AskUserQuestion call. The first option for each is pre-filled from the spec (scenarios in §7's first-prototype scope, their Thens, §8 success criteria) so the developer confirms or corrects rather than retyping; other options come from the request:
- **Scenarios**: which scenario IDs are in scope
- **Start / End**: the state the run begins in and where it stops
- **Purpose**: what this run is for (check predictions, find bugs, check the flow, verify a recent change, ...)
- **Pass if**: what result counts as a pass

If an answer is vague ("everything", "just check it"), ask again about that answer only. Then restate it in one line, `Testing <scenarios>, <start> → <end>, to <purpose>. Pass if <criterion>.`, and proceed.

## 2. Reviewers

Reviewers are every file in `.claude/personas/` plus every persona linked in the spec's §3. If §3 names none or a file is missing, follow step 2 of `/spec review` (`.claude/skills/spec/SKILL.md`) to ask the developer and create them. Skip this step for `test`.

## 3. Testing team: TDD in `Test/`

`/prototype` writes tests for the scenarios it builds; this team covers the rest of the scope (exceptional scenarios, scenarios added since) and reruns the whole suite. If §6 Test cannot check a scenario's Then (usually something the user sees), set up E2E with the developer first: `.claude/skills/qa/e2e.md` (next to this file).

1. **Test cases**: for each in-scope scenario without a test in `Test/` that names its ID, draft one case: `S3: given <Given>, when <When>, assert <Then>`. Show all drafts in one AskUserQuestion (approve all / edit). The asserted result is the developer's Then, verbatim in meaning; never invent a different expectation.
2. **Write** the approved cases in `Test/`, one test per scenario, named with its ID (`test_S3_<name>`, `S3 <name>`, ... per the runner's convention), using §6 Test's runner. No fixtures or helpers beyond what two tests share.
3. **Run** the whole `Test/` suite with §6 Test. A failing test is a finding: report it, never fix the app or weaken the test here. (Making it pass is the next `/prototype`.)
4. Write `{run}/test.md`: command, result per test with its scenario ID, and failure output.

## 4. Use sessions (for the use review)

1. **Plan** one session per reviewer, from that persona's **Use lens** and the in-scope scenarios. Stakeholder sessions follow the persona's Tasks, How they use it, and Breaking points: their order, their mistakes, their unexpected actions. Each step: action, expected result (the scenario's Then where one applies), and what to capture.
2. Show all plans in chat in one message and ask once: run as planned, or edit. The developer may add or remove steps.
3. **Run** each session from the agreed Start state, resetting the app between sessions. Operate the app with the first method that works:
   1. The method in §6 Operate (browser automation, CLI, API calls, ...). Throwaway driver scripts go in a temp dir, never in the project or `Test/`.
   2. The developer operates it and tells you at each step; you capture.
4. After every step, save the capture to `{run}/{persona}/NN-<step>.png` (for apps without a screen, the terminal or response output as `NN-<step>.txt`) and read the logs.
5. Write `{run}/{persona}/evidence.md`, facts only: for each step the action, expected, observed, capture file, and log lines. Then all errors and warnings.
6. Stop the app. Delete only the app data the sessions created (test accounts, saved files, database rows). Never touch source files, `Test/`, or git state.

## 5. Review independently

Skip a reviewer whose persona file says "None" for every lens this run uses (Code lens for `code`, Use lens for `use`). Launch one `persona-reviewer` agent per remaining reviewer, **in parallel, in one message**. The prompts are identical except for the persona file and the session folder: the persona file path, "Mode: QA", the report language, the spec path, `{run}/test.md` if it exists, the reviewer's own `{run}/{persona}/` folder (tell them to view every capture) for `use`, the code to read for `code` (the files changed since the last QA report's commit if in git, else §6 Source root), and the per-reviewer section of `template.md` (from `## {{Reviewer}}` to the end) as the format to return. Do not add your own opinions, and never pass one reviewer's output to another.

## 6. Write the report

Write `QA/{date}-{title}.md` from `template.md` (next to this file):
- Reviewer sections go in **exactly as returned**.
- **Scenarios** puts the developer's Then next to what tests and sessions observed. Do not judge whether a prediction held.
- **Result** checks "Pass if" against the evidence, citing the test or step that shows it.
- **Bugs** lists only reproducible defects found in the evidence or by reviewers.
- "Raised by more than one reviewer" and "Where reviewers disagree" come only from the reviewer sections.

In chat: the result line, the scenario table, failing tests, the reviewer table, and the report path. End with: "Run `/reflect` to decide what this means."

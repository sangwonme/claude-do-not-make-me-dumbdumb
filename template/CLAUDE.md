# CLAUDE.md

> Written for Claude. Humans don't need to read this file.

Prototype-first project. The goal is to test the developer's idea fast, with the developer thinking through every step: they write the spec, predict the results, and decide what the results mean. Claude builds, runs, and reports; it never does the developer's thinking for them.

## Project

Framework, run command, test command, and how to operate the app live in the spec's **Framework** section (`Spec/*.md`), not here. They can change between specs. If they are missing, ask the developer to fill them in; never pick a framework yourself.

## Where things live

| Path | Written by | Rule |
|---|---|---|
| `Spec/*.md` | The developer only | Never add content, ideas, or numbers. After `/spec setup` creates it, only `/spec refine`, the stakeholder step of `/spec review`, and the E2E setup in `.claude/skills/qa/e2e.md` (§6 Test / Operate) change it, and only from the developer's answers. Everything in it counts as explicitly requested. |
| `Docs/Personas/*.md` | The developer only | Stakeholder users. Created by `/persona` from the developer's interview answers, recorded in their words. Reviewers read them here directly; never copy them elsewhere. |
| `Docs/Decisions/*.md` | The developer only | What a prototype or QA run meant and what happens next. Created by `/reflect` from the developer's answers. |
| `Spec/review/`, `QA/` | `/spec review`, `/qa` | Reports and evidence. Never edit past ones. Write them in the spec's language (no spec: the user's language). |
| `Test/` | Claude (`/prototype`, `/qa`) | All test code, unit and E2E. Each test names the spec scenario it checks (`S1`, `S2`, ...). The developer approves new test cases before they are written. Tests are written before the code they check. |
| `.claude/personas/` | Developer and Claude | The core reviewers (senior dev, UX designer, HCI researcher). |
| Everything else | Claude | Source code, laid out as the spec's Framework section says. No deeper structure until it hurts. |

`Spec/` says what to build and what result to expect, ponytail says how little code to write. If they disagree, `Spec/` wins; if anything is unclear, ask the developer.

## The developer's thinking stays with the developer

- Never fill in a prediction, scenario, success criterion, persona, or conclusion for the developer. If one is missing, name the section and stop.
- When asking, offer readings of what the developer already wrote, never new ideas. The developer can always answer in their own words.
- Report observed results next to the developer's expected results. Do not judge whether the idea worked; that is the developer's call in `/reflect`.
- Persona reviews are simulated. Every report says so, and none may be presented as user-study evidence.

## Ponytail: always on

All code follows the `ponytail` skill (`.claude/skills/ponytail/SKILL.md`) at **full**, unless the user changes the level with `/ponytail`.

Ponytail decides how little to build, never what the developer asked for. Do not cut or argue with anything in `Spec/` (its first-prototype scope included), and never skip the questions `/spec`, `/persona`, `/qa`, and `/reflect` require.

- Mark deliberate shortcuts as `ponytail: <ceiling>, <upgrade path>` comments so `/ponytail-debt` can collect them.
- Code shape (no needless abstraction, no needless function splitting) is defined once, in the Code lens of `.claude/personas/senior-dev.md`. Follow it when writing code.
- A function named after a step of the spec's §4 Core logic is not a `ponytail-review` cut, even with one caller: it is how the code reads like the paper's explanation.

## Done means verified

1. Run the app with the spec's run command. Not done while it errors.
2. If `Test/` has tests, run the spec's test command. Not done while a test for the touched scenarios fails.
3. When behavior matters, operate the app the way the spec's Framework section says and capture what happened.

## Skills

| Skill | Who starts it | When |
|---|---|---|
| `prototype` | You or the user | Building a scenario from the spec |
| `ponytail-review`, `ponytail-debt` | You or the user | `prototype` runs `ponytail-review` on itself; `ponytail-debt` when a prototype graduates |
| `spec`, `persona`, `qa`, `reflect`, `restructure` | The user only | Never run their steps on your own, except where one of them tells you to follow another. Suggest them when useful. |

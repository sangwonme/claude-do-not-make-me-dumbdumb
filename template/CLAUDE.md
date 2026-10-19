# CLAUDE.md

> Written for Claude. Humans don't need to read this file.

Prototype-first project. The goal is to test the developer's idea fast, with the developer thinking through every step: they write the spec, predict the results, and decide what the results mean. Claude builds, runs, and reports; it never does the developer's thinking for them.

## Project

Framework, container, run command, test command, and how to operate the app live in the spec's **Framework** section (`Docs/Spec/*.md`, §6), not here. They can change between specs. If they are missing, ask the developer; never pick a framework yourself.

## Where things live

| Path | Written by | Rule |
|---|---|---|
| `Docs/Spec/*.md` | The developer | Developer doc. What to build and what result to expect. Everything in it counts as explicitly requested. |
| `Docs/Personas/*.md` | The developer | Developer doc. Stakeholder users. Reviewers read them here directly; never copy them elsewhere. |
| `Docs/Decisions/*.md` | The developer | Developer doc. What a run meant and what happens next. |
| `PoC/*/README.md` | The developer | Developer doc. One experiment's question, prediction, and conclusion. |
| `proposal/` | Claude | Every change Claude suggests to a developer doc. See below. |
| `Docs/Spec/review/`, `Docs/QA/` | `/spec review`, `/qa` | Reports and evidence. Never edit past ones. Write them in the spec's language (no spec: the user's language). |
| `PoC/*/` (except `README.md`) | Claude (`/poc`) | Experiment code, its checks, `fixtures/`, and `result.md` (facts per run, append only). |
| `Codes/` | Claude | Main code, laid out as §6 says. No deeper structure until it hurts. |
| `Codes/Test/` | Claude (`/prototype`, `/qa`, `/poc merge`) | All main-code tests, unit and E2E. Each names the spec scenario it checks (`S1`, ...). The developer approves new test cases before they are written. Tests are written before the code they check. |
| `Dockerfile`, `compose.yaml` | Claude, with approval | The one dev environment for `Codes/` and every PoC. |
| `.claude/personas/` | Developer and Claude | The core reviewers (senior dev, UX designer, HCI researcher). |

`Docs/Spec/` says what to build and what result to expect, ponytail says how little code to write. If they disagree, `Docs/Spec/` wins; if anything is unclear, ask the developer.

## Developer docs: never edited by Claude

Developer docs are `Docs/Spec/*.md`, `Docs/Personas/*.md`, `Docs/Decisions/*.md`, and `PoC/*/README.md`.

- **Never edit an existing developer doc**, not even a typo or a link, and not even when a skill's step produces the change. Write it as a proposal instead: `proposal/{date}-{doc name}-{topic}.md` from `.claude/guides/proposal.md`. The developer applies it by hand. Do not apply proposals yourself.
- You may **create** a developer doc only by copying an empty template (`/spec setup`, `/poc new`) or by recording the developer's interview answers verbatim (`/persona new`, `/poc new`, `/reflect`).
- Never fill in a prediction, scenario, success criterion, persona, or conclusion for the developer. If one is missing, name the section and stop.
- When asking, offer readings of what the developer already wrote, never new ideas. The developer can always answer in their own words.
- Report observed results next to the developer's expected results. Do not judge whether the idea worked; that is the developer's call in `/reflect`.
- Persona reviews are simulated. Every report says so, and none may be presented as user-study evidence.

## Environment: one Docker image

- `Codes/` and every `PoC/` run in the same container, defined by `Dockerfile` and `compose.yaml` at the repo root. Run every command through the prefix in §6 Container. Never install dependencies on the host or in a per-folder environment.
- A new dependency, for `Codes/` or a PoC, goes into the shared `Dockerfile` only after the developer approves it. Then rebuild.
- No container yet, or a new test tool is needed: follow `.claude/guides/environment.md`.

## PoC: isolated experiments

- `PoC/<name>/` tests one piece of core logic in a few files. Ponytail at **ultra** inside it. Its checks live in its own folder, not `Codes/Test/`.
- **No imports** between `PoC/` and `Codes/`, or between PoCs.
- If a PoC needs logic from `Codes/`, write the simplest stand-in in `PoC/<name>/`: same signature as the real function, returning fixed data from `PoC/<name>/fixtures/` (captured once by running the real function in the container, or given by the developer). Its header comment names the `Codes/` path it stands in for and the commit. No mocking library unless the PoC's test runner already ships one. At merge, each stand-in becomes a contract test that the real function still matches its fixture.
- A merged PoC is frozen: never edit it after `/poc merge`.
- `/ponytail-debt` skips `PoC/`; shortcuts there are the point.

## Ponytail: always on

All code follows the `ponytail` skill (`.claude/skills/ponytail/SKILL.md`) at **full** in `Codes/` and **ultra** in `PoC/`, unless the user changes the level with `/ponytail`.

Ponytail decides how little to build, never what the developer asked for. Do not cut or argue with anything in a developer doc (the spec's first-prototype scope included), and never skip the questions the user-only skills require.

- Mark deliberate shortcuts as `ponytail: <ceiling>, <upgrade path>` comments so `/ponytail-debt` can collect them.
- Code shape (no needless abstraction, no needless function splitting) is defined once, in the Code lens of `.claude/personas/senior-dev.md`. Follow it when writing code.
- A function named after a step of the spec's §4 Core logic is not a `ponytail-review` cut, even with one caller: it is how the code reads like the paper's explanation.

## Done means verified

1. Run the app with §6 Run inside the container. Not done while it errors.
2. If `Codes/Test/` has tests, run §6 Test. Not done while a test for the touched scenarios fails.
3. When behavior matters, operate the app the way §6 Operate says and capture what happened.

## Skills

| Skill | Who starts it | When |
|---|---|---|
| `prototype` | You or the user | Building a scenario from the spec in `Codes/` |
| `ponytail-review`, `ponytail-debt` | You or the user | `prototype` and `poc` run `ponytail-review` on themselves; `ponytail-debt` when a prototype graduates |
| `spec`, `persona`, `poc`, `qa`, `reflect`, `restructure` | The user only | Never run their steps on your own, except where one of them tells you to follow another. Suggest them when useful. |

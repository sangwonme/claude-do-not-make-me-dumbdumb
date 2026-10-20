# claude-do-not-make-me-dumbdumb

A Claude Code setup for prototyping and validating your own ideas without handing your thinking to Claude. You write the spec, predict the results, and decide what they mean. Claude builds, tests, runs reviewers, and asks you questions. Built on [ponytail](template/.claude/skills/ponytail/SKILL.md): the laziest solution that works.

Works for any kind of app. Everything runs in one Docker image.

```
PoC/<name>/   your core-logic experiments, one folder each
Codes/        the main code, with its tests in Codes/Test/
Docs/         your docs: Spec/, Personas/, Decisions/ (and Claude's reports: Spec/review/, QA/)
Proposal/     changes Claude suggests to your docs. Claude never edits them; you apply proposals by hand
```

## Install

Open Claude Code in your project folder and type:

```
Install the setup from https://github.com/sangwonme/claude-do-not-make-me-dumbdumb
```

## Use

| You do | Claude does |
|---|---|
| `/spec setup [title]` | Creates a spec template in `Docs/Spec/`. **You write the spec yourself**: contribution, core logic, Given-When-Then scenarios with your expected results, and the framework. |
| `/persona new [name]` | Interviews you about a stakeholder user and saves your answers to `Docs/Personas/` |
| `/spec refine` | Asks you about unclear or redundant wording, then writes a proposal from your answers in `Proposal/` |
| `/spec review` | A senior developer, a UX designer, an HCI researcher, and your stakeholder users review it independently → `Docs/Spec/review/` |
| `/prototype [scenarios]` | Writes tests for your scenarios (you approve them), builds the smallest version that passes, and shows what happened next to what you expected |
| `/poc new\|run\|merge\|drop <name>` | An isolated experiment in `PoC/<name>/`: you state the question and prediction, Claude builds and runs the smallest version and records facts, and on your decision merges it into `Codes/` test-first |
| `/qa` | Agrees on scope with you, then: runs and extends scenario tests in `Codes/Test/`, has every reviewer use the app their own way with logs and captures, and has each review the code and their session → `Docs/QA/`. `/qa code PoC/<name>` reviews one PoC's code |
| `/reflect` | Asks what the results mean and what you'll do next, and saves your answers to `Docs/Decisions/` |
| `/restructure` | After you decide to change the framework or the code's shape, moves the code to your target, ports the tests, and proves nothing broke |
| `/ponytail-debt` | Lists the shortcuts it took, for when a prototype graduates |

Core reviewers live in `.claude/personas/`; your stakeholder users live in `Docs/Personas/`. Edit any of them.

### Workflows

Four scenarios, all following one running example: a feedback tool for teachers, specified in `Docs/Spec/essay-feedback.md`.

#### A. Build an idea: spec → prototype → QA → decision

The main path. Use it for anything the user does.

1. **Write the spec.** `/spec setup essay-feedback` creates the template. You fill it in: the contribution, the core logic, Given-When-Then scenarios (`S1`, `S2`, ...) with the result you expect and why, and the framework.
2. **Describe your users.** `/persona new` for each kind of user. Claude interviews you; the persona is your answers, saved in `Docs/Personas/`.
3. **Sharpen the wording.** `/spec refine` asks about vague or conflicting wording. You answer; it writes a proposal in `Proposal/` with the exact before and after, and you apply it.
4. **Get it reviewed.** `/spec review`. If the spec names no stakeholders yet, Claude asks which ones first. Reviewers work independently; you get their verdicts, where they agree and disagree, and questions only you can answer. You edit the spec.
5. **Build it.** `/prototype S1 S2`. If a scenario has no expected result or no "why", Claude stops and tells you what to write. Otherwise it drafts one test per scenario from your Then, you approve, the tests fail first, and Claude builds in `Codes/` until they pass. You get your expected result next to what happened; Claude does not say whether you were right.
6. **Validate it.** `/qa`. You confirm the scope, purpose, and pass criterion (pre-filled from your spec). Then:
   - Testing team: missing scenario tests are drafted for your approval, and the whole `Codes/Test/` suite runs. Failures are reported, not fixed.
   - Reviewer team: you approve a usage plan per persona (a UX designer tries edge actions, your stakeholder users follow their own habits and mistakes). Claude operates the app and captures every step.
   - Each reviewer independently reviews their own session and, if their role reads code, the code. The report in `Docs/QA/` puts your predictions, test results, bugs, and reviews side by side.
   - `/qa test`, `/qa code`, or `/qa use` runs one part only.
7. **Decide what it means.** `/reflect` shows the facts without interpretation, then asks you: did each prediction hold and why, what surprised you, which reviewer points you accept or reject, what it means for your contribution, and what you decide (drop, iterate, take further, change framework). Your answers go to `Docs/Decisions/`.
8. **Iterate.** Edit the spec, then `/prototype` the changed scenarios (failing tests from the last QA become the target) and `/qa` again.

The first time Claude needs a Docker image, a test tool, or an E2E tool, it asks you which one (from a per-stack guide), sets it up, and proposes the lines for your spec's Framework section.

#### B. Test a piece of core logic in a PoC, then merge it

Use it when one step of your core logic is a question you can't settle by thinking: does this approach work, how accurate is it, how fast. A PoC is a few files in its own folder, away from `Codes/`, so you can try something risky, throw it away, or try two approaches side by side. Example: core logic step 2, "group similar feedback comments", and you're not sure simple clustering is good enough.

1. **Ask the question.** `/poc new clustering` interviews you, and your answers become `PoC/clustering/README.md`:
   - Question: can simple clustering group comments the way a teacher would? (§4, step 2)
   - Prediction: 8 of 10 groups match mine, because most comments repeat the same few phrases.
   - Observe: the groups for 50 sample comments, side by side with my hand-made groups.
   - Merge if 8 or more match; drop if fewer than 5.
2. **Run it.** `/poc run clustering` builds the smallest experiment in `PoC/clustering/` and runs it in the same Docker image as `Codes/`:
   - The experiment is a few files plus one check that prints or asserts exactly what "Observe" names.
   - It never imports from `Codes/`. When it needs main-code logic (here, loading comments), it uses a stand-in with the same signature that returns data recorded once from the real function into `fixtures/`, so the experiment stays isolated and repeatable.
   - A new library is added to the shared `Dockerfile` only after you approve, marked as belonging to this PoC.
   - Facts from every run go to `result.md`: command, output, and your prediction next to what happened.
3. **Decide.** Read `result.md` and write your Conclusion in the PoC's README (merge, drop, or run again with what change), or `/reflect` on it. Before merging, `/qa code PoC/clustering` has the senior developer and the HCI researcher check whether the logic is simple and explains your contribution clearly.
4. **Merge it.** `/poc merge clustering` asks which scenarios this logic serves and shows a map for your approval: what goes where in `Codes/`, which stand-ins become real calls, and which libraries move into the main dependencies. It writes the tests first (scenario tests, plus a contract test per stand-in that the real function still matches its fixture), then builds until they pass without breaking any test that already passed. Continue with A, step 6.
5. **Or drop it.** `/poc drop clustering` removes the libraries it added.

Either way the folder stays, frozen, as a record of what you tried and learned. To compare approaches, make two PoCs (say `clustering` and `clustering-embeddings`) with their own predictions and decide from their `result.md` files.

#### C. Change the framework or the code's shape

Use it when a decision says the code should be organized differently, for example after the HCI researcher says it doesn't read like your paper's explanation.

1. **Decide.** Record the decision in `/reflect` (change framework, or accept a reviewer's reframe).
2. **Update the spec.** Edit the Framework section (or Core logic, if your explanation changed) yourself.
3. **Restructure.** `/restructure` asks for your target structure, records which tests pass now, and shows a map of what moves where for your approval. It moves the code and ports the tests, deletes what's left behind, and proves the same tests still pass.
4. **Re-check.** `/qa code` has the reviewers check the new shape.

#### D. Graduate a prototype

Use it when a prototype is turning into something you'll keep.

1. **Collect the shortcuts.** `/ponytail-debt` lists every shortcut taken in `Codes/`, with when to revisit it. PoCs are left out; shortcuts there are the point.

Persona reviews are simulated. They help you think; they are not user-study evidence.

Everything else (`CLAUDE.md`, `.claude/`, and the rest of this README) is written for Claude. You don't need to read it.

---

## For agents

> Humans can stop here. Everything below is instructions for Claude.

### Install procedure

Run this when the user asks to install this setup.

1. The target is the current directory unless the user names another.
2. Shallow-clone this repo into a temp directory outside the project.
3. Run the installer with the project as the target:
   - Windows: `powershell -NoProfile -ExecutionPolicy Bypass -File <clone>/install.ps1 -Target <project>`
   - macOS / Linux: `bash <clone>/install.sh <project>`
4. The installer skips files that already exist. Resolve each skipped file:
   - `CLAUDE.md`: merge the template's sections into it.
   - `.claude/settings.json`: merge the template's keys and list entries into it.
   - Anything else: ask the user before overwriting.
5. Delete the temp clone.
6. Tell the user to restart Claude Code in the project folder so `CLAUDE.md` loads, then to run `/spec setup`.

### What gets installed

| Path | Contents |
|---|---|
| `CLAUDE.md` | Where things live and who writes them, developer docs never edited by Claude (proposals instead), one Docker image, PoC isolation and stand-ins, ponytail always on (full in `Codes/`, ultra in `PoC/`), definition of done, which skills Claude may start |
| `.claude/settings.json` | Asks before any write to developer docs (`Docs/Spec/*.md`, `Docs/Personas/`, `Docs/Decisions/`, `PoC/*/README.md`) and to `Dockerfile` / `compose.yaml` |
| `Docs/Personas/README.md` | Home of the stakeholder personas, so the folder ships |
| `PoC/README.md`, `Proposal/README.md` | What each folder is for, so the folders ship |
| `.claude/guides/proposal.md` | The proposal format for changes to developer docs |
| `.claude/guides/environment.md` | Docker setup, and per-stack test, E2E, and operate tools |
| `.claude/agents/persona-reviewer.md` | The one reviewer agent. Takes a persona file and holds the shared rules (independent, cite sources, read-only) |
| `.claude/personas/senior-dev.md` | Spec, code (no needless abstraction, no needless function splitting), and use lens |
| `.claude/personas/ux-designer.md` | UX principles, unclear Given-When-Then, exceptional user actions |
| `.claude/personas/hci-researcher.md` | Can the contribution be explained simply, and does the code's structure match that explanation |
| `.claude/skills/spec` | `/spec setup\|refine\|review`. `templates/spec.md` (9 sections, filled in by the developer) and `templates/review.md`. `refine` writes proposals |
| `.claude/skills/persona` | `/persona new\|list`: interview → `Docs/Personas/{name}.md` from `template.md` |
| `.claude/skills/prototype` | `/prototype`: load ponytail → check the developer's predictions exist → approved tests (red) → build (green) → run → ponytail-review self-check → expected vs. observed |
| `.claude/skills/poc` | `/poc new\|run\|merge\|drop`: interview → `PoC/<name>/README.md` from `template.md` → run in the container → `result.md` → test-first merge into `Codes/`, or drop |
| `.claude/skills/qa` | `/qa [test\|code\|use]`: scope interview → stakeholders → TDD in `Codes/Test/` → per-persona use sessions → independent reviews → report from `template.md`. `/qa code PoC/<name>` for one PoC |
| `.claude/skills/reflect` | `/reflect`: facts → interview → `Docs/Decisions/{date}-{title}.md` from `template.md` |
| `.claude/skills/restructure` | `/restructure`: developer's target → test baseline → approved map → move and port → same tests pass |
| `.claude/skills/ponytail` | The YAGNI ladder. `/ponytail lite\|full\|ultra` changes the level |
| `.claude/skills/ponytail-review` | `/ponytail-review`: what to delete from a diff |
| `.claude/skills/ponytail-debt` | `/ponytail-debt`: ledger of `ponytail:` shortcuts |

The installer also adds `.claude/settings.local.json` and `CLAUDE.local.md` to `.gitignore`, creating the file if needed.

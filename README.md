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

**1. From idea to spec**
1. `/spec setup my-idea` creates `Docs/Spec/my-idea.md`. You fill it in: the contribution, the core logic, Given-When-Then scenarios with the result you expect and why, and the framework.
2. `/persona new` for each kind of user. Claude interviews you; the persona is your answers.
3. `/spec refine` asks about vague or conflicting wording. You answer; it writes a proposal with the exact before and after, and you apply it.
4. `/spec review`. If the spec names no stakeholders yet, Claude asks which ones first. Reviewers work independently; you get their verdicts, where they agree and disagree, and questions only you can answer. You edit the spec.

The first time Claude needs a Docker image, a test tool, or an E2E tool, it asks you which one (from a per-stack guide), sets it up, and proposes the lines for your spec's Framework section.

**2. Experiment on core logic in a PoC**

A PoC answers one question about your core logic that you can't settle by thinking: does this approach work, how accurate is it, how fast. It lives in its own folder with a few files, away from the main code, so you can try something risky, throw it away, or try two approaches side by side without touching `Codes/`. Use `/prototype` when you are building what the user does (your scenarios); use a PoC when you are testing how one step of the core logic works.

Example: your spec's core logic has a step "group similar feedback comments", and you're not sure a simple approach is good enough.

1. **Ask the question.** `/poc new clustering` interviews you, and your answers become `PoC/clustering/README.md`:
   - *Question*: can simple clustering group comments the way a teacher would? (core logic §4, step 2)
   - *Prediction*: 8 of 10 groups match mine, because most comments repeat the same few phrases.
   - *Observe*: the groups for 50 sample comments, side by side with my hand-made groups.
   - *Merge if* 8 or more match. *Drop if* fewer than 5.
2. **Run it.** `/poc run clustering` builds the smallest experiment and runs it in the same Docker image as `Codes/`. The folder ends up like this:
   ```
   PoC/clustering/
     README.md        your question, prediction, and later your conclusion. Claude never edits it
     cluster.*        the experiment, a few files at most
     check.*          prints or asserts exactly what "Observe" names
     stand_in.*       same signature as load_comments() in Codes/, returns the data below
     fixtures/        comments recorded once from the real Codes/ function
     result.md        facts from every run: command, output, your prediction next to what happened
   ```
   The PoC never imports from `Codes/`. When it needs main-code logic (here, loading comments), it uses a stand-in with the same signature that returns recorded data, so the experiment stays isolated and repeatable. If the experiment needs a new library, Claude asks first and adds it to the shared `Dockerfile`, marked as belonging to this PoC.
3. **Decide.** Read `result.md` and write your Conclusion in the PoC's README (merge, drop, or run again with what change), or `/reflect` on it. Claude reports what happened but never says whether you were right. Before merging, `/qa code PoC/clustering` can have the senior developer and the HCI researcher check whether the logic is simple and explains your contribution clearly.
4. **Merge or drop.**
   - `/poc merge clustering` asks which spec scenarios this logic serves, and shows a map for your approval: what goes where in `Codes/`, which stand-ins become real calls, and which libraries move into the main dependencies. It writes the tests first: scenario tests, plus a contract test for each stand-in that checks the real function still returns data like the fixture. Then it builds until they pass, without breaking any test that already passed.
   - `/poc drop clustering` removes the libraries it added.
   - Either way the folder stays, frozen, as a record of what you tried and what you learned. Useful when you write the paper.

To compare approaches, make two PoCs (say `clustering` and `clustering-embeddings`) with their own predictions, run both, and decide from their `result.md` files.

**3. Build and test a scenario**
1. `/prototype S1 S2`. If a scenario has no expected result or no "why", Claude stops and tells you what to write.
2. Claude drafts one test per scenario from your Then; you approve; the tests fail first, then Claude builds until they pass. If your stack has no E2E tool yet, Claude asks you to pick one from a per-stack guide.
3. You get a table of your expected result next to what happened. Claude does not say whether you were right.

**4. Validate**
1. `/qa`. You confirm the scope, purpose, and pass criterion (pre-filled from your spec).
2. Testing team: missing scenario tests are drafted for your approval, then the whole `Codes/Test/` suite runs. Failures are reported, not fixed.
3. Reviewer team: you approve a usage plan per persona (each uses the app their own way: a UX designer tries edge actions, your stakeholder users follow their own habits and mistakes). Claude operates the app and captures every step.
4. Each reviewer independently reviews their own session and, if their role reads code, the code. The report puts your predictions, test results, bugs, and reviews side by side.
5. `/qa test`, `/qa code`, or `/qa use` runs one part only.

**5. Decide what it means**
1. `/reflect` shows the facts without interpretation, then asks you: did each prediction hold and why, what surprised you, which reviewer points you accept or reject, what it means for your contribution, and what you decide (drop, iterate, take further, change framework, or for a PoC: merge, drop, another PoC).
2. Your answers go to `Docs/Decisions/`, with a list of spec sections you said you'd change.

**6. Iterate**
Edit the spec, then `/prototype` the changed scenarios (failing tests from the last QA become the target) and `/qa` again.

**7. Change the framework or the code's shape**
1. You decide in `/reflect` (for example, after the HCI researcher says the code doesn't read like your paper's explanation).
2. Update the spec's Framework section (or Core logic, if your explanation changed).
3. `/restructure` asks for your target structure, shows a map of what moves where for your approval, records which tests pass now, moves the code and ports the tests, deletes what's left behind, and proves the same tests still pass. Then `/qa code` to have the reviewers check the new shape.

**8. Graduate**
`/ponytail-debt` lists every shortcut taken, with when to revisit it.

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

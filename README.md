# claude-do-not-make-me-dumbdumb

A Claude Code setup for prototyping and validating your own ideas without handing your thinking to Claude. You write the spec, predict the results, and decide what they mean. Claude builds, tests, runs reviewers, and asks you questions. Built on [ponytail](template/.claude/skills/ponytail/SKILL.md): the laziest solution that works.

Works for any kind of app.

## Install

Open Claude Code in your project folder and type:

```
Install the setup from https://github.com/sangwonme/claude-do-not-make-me-dumbdumb
```

## Use

| You do | Claude does |
|---|---|
| `/spec setup [title]` | Creates a spec template in `Spec/`. **You write the spec yourself**: contribution, core logic, Given-When-Then scenarios with your expected results, and the framework. |
| `/persona new [name]` | Interviews you about a stakeholder user and saves your answers to `Docs/Personas/` |
| `/spec refine` | Asks you about unclear or redundant wording, then edits using only your answers |
| `/spec review` | A senior developer, a UX designer, an HCI researcher, and your stakeholder users review it independently → `Spec/review/` |
| `/prototype [scenarios]` | Writes tests for your scenarios (you approve them), builds the smallest version that passes, and shows what happened next to what you expected |
| `/qa` | Agrees on scope with you, then: runs and extends scenario tests in `Test/`, has every reviewer use the app their own way with logs and captures, and has each review the code and their session → `QA/` |
| `/reflect` | Asks what the results mean and what you'll do next, and saves your answers to `Docs/Decisions/` |
| `/restructure` | After you decide to change the framework or the code's shape, moves the code to your target, ports the tests, and proves nothing broke |
| `/ponytail-debt` | Lists the shortcuts it took, for when a prototype graduates |

Core reviewers live in `.claude/personas/`; your stakeholder users live in `Docs/Personas/`. Edit any of them.

### Workflows

**1. From idea to spec**
1. `/spec setup my-idea` creates `Spec/my-idea.md`. You fill it in: the contribution, the core logic, Given-When-Then scenarios with the result you expect and why, and the framework.
2. `/persona new` for each kind of user. Claude interviews you; the persona is your answers.
3. `/spec refine` asks about vague or conflicting wording. You answer; it edits only those words.
4. `/spec review`. If the spec names no stakeholders yet, Claude asks which ones first. Reviewers work independently; you get their verdicts, where they agree and disagree, and questions only you can answer. You edit the spec.

**2. Build and test a scenario**
1. `/prototype S1 S2`. If a scenario has no expected result or no "why", Claude stops and tells you what to write.
2. Claude drafts one test per scenario from your Then; you approve; the tests fail first, then Claude builds until they pass. If your stack has no E2E tool yet, Claude asks you to pick one from a per-stack guide.
3. You get a table of your expected result next to what happened. Claude does not say whether you were right.

**3. Validate**
1. `/qa`. You confirm the scope, purpose, and pass criterion (pre-filled from your spec).
2. Testing team: missing scenario tests are drafted for your approval, then the whole `Test/` suite runs. Failures are reported, not fixed.
3. Reviewer team: you approve a usage plan per persona (each uses the app their own way: a UX designer tries edge actions, your stakeholder users follow their own habits and mistakes). Claude operates the app and captures every step.
4. Each reviewer independently reviews their own session and, if their role reads code, the code. The report puts your predictions, test results, bugs, and reviews side by side.
5. `/qa test`, `/qa code`, or `/qa use` runs one part only.

**4. Decide what it means**
1. `/reflect` shows the facts without interpretation, then asks you: did each prediction hold and why, what surprised you, which reviewer points you accept or reject, what it means for your contribution, and what you decide (drop, iterate, take further, change framework).
2. Your answers go to `Docs/Decisions/`, with a list of spec sections you said you'd change.

**5. Iterate**
Edit the spec, then `/prototype` the changed scenarios (failing tests from the last QA become the target) and `/qa` again.

**6. Change the framework or the code's shape**
1. You decide in `/reflect` (for example, after the HCI researcher says the code doesn't read like your paper's explanation).
2. Update the spec's Framework section (or Core logic, if your explanation changed).
3. `/restructure` asks for your target structure, shows a map of what moves where for your approval, records which tests pass now, moves the code and ports the tests, deletes what's left behind, and proves the same tests still pass. Then `/qa code` to have the reviewers check the new shape.

**7. Graduate**
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
| `CLAUDE.md` | Where things live and who writes them, the developer's thinking stays with the developer, ponytail always on (full) and its limits, definition of done, which skills Claude may start |
| `.claude/settings.json` | Asks before any edit to `Spec/*.md` or `Docs/`, the developer-written files |
| `Docs/Personas/README.md` | Home of the stakeholder personas, so the folder ships |
| `.claude/agents/persona-reviewer.md` | The one reviewer agent. Takes a persona file and holds the shared rules (independent, cite sources, read-only) |
| `.claude/personas/senior-dev.md` | Spec, code (no needless abstraction, no needless function splitting), and use lens |
| `.claude/personas/ux-designer.md` | UX principles, unclear Given-When-Then, exceptional user actions |
| `.claude/personas/hci-researcher.md` | Can the contribution be explained simply, and does the code's structure match that explanation |
| `.claude/skills/spec` | `/spec setup\|refine\|review`. `templates/spec.md` (9 sections, filled in by the developer) and `templates/review.md` |
| `.claude/skills/persona` | `/persona new\|list`: interview → `Docs/Personas/{name}.md` from `template.md` |
| `.claude/skills/prototype` | `/prototype`: load ponytail → check the developer's predictions exist → approved tests (red) → build (green) → run → ponytail-review self-check → expected vs. observed |
| `.claude/skills/qa` | `/qa [test\|code\|use]`: scope interview → stakeholders → TDD in `Test/` → per-persona use sessions → independent reviews → report from `template.md`. `e2e.md`: per-stack E2E test and operate setup |
| `.claude/skills/reflect` | `/reflect`: facts → interview → `Docs/Decisions/{date}-{title}.md` from `template.md` |
| `.claude/skills/restructure` | `/restructure`: developer's target → test baseline → approved map → move and port → same tests pass |
| `.claude/skills/ponytail` | The YAGNI ladder. `/ponytail lite\|full\|ultra` changes the level |
| `.claude/skills/ponytail-review` | `/ponytail-review`: what to delete from a diff |
| `.claude/skills/ponytail-debt` | `/ponytail-debt`: ledger of `ponytail:` shortcuts |

The installer also adds `.claude/settings.local.json` and `CLAUDE.local.md` to `.gitignore`, creating the file if needed.

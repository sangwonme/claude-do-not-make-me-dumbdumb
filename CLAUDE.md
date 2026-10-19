# CLAUDE.md

> Written for Claude. Humans don't need to read this file.

This repo is a **Claude Code setup template for prototyping and validating ideas with the developer thinking through every step**. Users don't run anything themselves: they ask Claude in their project to install it, and Claude follows the "For agents" section of `README.md`. Adapted from [claude-is-the-best-game-director](https://github.com/sangwonme/claude-is-the-best-game-director); the target app can be anything, so never assume a stack.

## Rules for editing this repo

- All docs in this repo (including everything under `template/`) are written in English. Reports generated inside a project follow that project's spec language.
- README audience: the part above "For agents" is for humans and stays very high level. Everything Claude needs goes below it.
- Apply ponytail to the template itself: add a file, agent, or rule only when a real session needed it or the user asked for it.
- `template/.claude/skills/ponytail*` are vendored copies of the MIT-licensed ponytail skills. Do not edit them; re-copy from upstream to update. Project-specific ponytail guidance goes in `template/CLAUDE.md`.
- Never name a specific framework, language, or automation tool in `template/`, except as options in `template/.claude/skills/qa/e2e.md`. The spec's Framework section decides those per project.

## Invariants (check these after any change)

- **Developer authorship**: the developer writes `Spec/`, `Docs/Personas/`, and `Docs/Decisions/`. No skill or agent may author their content; `/spec refine`, `/persona`, `/reflect`, the stakeholder step of `/spec review`, and the E2E setup in `e2e.md` (§6 Test / Operate) only record the developer's answers. `template/.claude/settings.json` asks before every edit there.
- **Predictions before building**: `/prototype` stops if the picked scenarios lack Given, When, Then, or "Why I expect this". `/prototype`, `/qa`, and `/reflect` show expected next to observed and never judge whether a prediction held.
- **Skill invocation**: `spec`, `persona`, `qa`, `reflect`, and `restructure` have `disable-model-invocation: true` (user-only). Every other skill must stay model-invocable. Keep the "Skills" table in `template/CLAUDE.md` in sync with the frontmatter.
- **Ponytail scope**: ponytail limits how much gets built. It never overrides `Spec/` content or the questions the user-only skills must ask.
- **Personas**: each layer written in one place only.
  - Core reviewers (who they are, spec/code/use lens): `template/.claude/personas/*.md`
  - Stakeholder users: the project's `Docs/Personas/*.md`, from `template/.claude/skills/persona/template.md`, whose fixed lens sections must keep the same headings as the core personas
  - Rules every reviewer shares: `template/.claude/agents/persona-reviewer.md`
  - Output format: each skill's template

  `/spec review` and `/qa` launch one `persona-reviewer` per core file plus one per stakeholder linked in the spec's §3, in parallel, and reviewers never see each other's output. Never hardcode persona names in skills or templates.
- **Simulated reviews**: every report template states that persona reviews are not user-study evidence.
- **Test-first**: all test code lives in `Test/` (except where `e2e.md` says a platform forbids it), one test per scenario, named with its scenario ID. `/prototype` writes the approved tests before the code; `/qa` reruns and extends them and never fixes the app; nothing weakens a test to pass it. `/restructure` ports tests without changing their asserted Then.
- **Code shape**: defined once, in the Code lens of `template/.claude/personas/senior-dev.md`. `template/CLAUDE.md` points to it and adds only the §4 exception to `ponytail-review`.
- **Behavior-preserving restructure**: `/restructure` runs only after the developer decided it, and passes only when every test that passed at baseline still passes.
- **Spec section numbers**: skills and personas reference `templates/spec.md` sections by number (§2 Contribution, §3 Stakeholders, §4 Core logic, §5 Scenarios, §6 Framework, §7 Scope, §8 Success criteria). Renumbering the template means updating every reference.
- **Paired files**:
  - `install.ps1` ↔ `install.sh` ↔ the README install procedure
  - Files under `template/` ↔ the "What gets installed" table in the README

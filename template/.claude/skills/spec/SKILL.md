---
name: spec
description: Spec workflow. "/spec setup [title]" creates a spec template in Spec/ for the developer to fill in. "/spec review [file]" has every core reviewer and every stakeholder persona the spec names review it independently, and writes Spec/review/{date}-{title}.md. "/spec refine [file]" asks the developer about unclear or redundant wording and edits from their answers.
disable-model-invocation: true
argument-hint: "setup [title] | review [file] | refine [file]"
---

# Spec

Arguments: $ARGUMENTS. The first word is the mode: `setup`, `review`, or `refine`. No mode → ask which one.

**The developer writes the spec.** Never add ideas, content, or numbers of your own to a file in `Spec/`. `setup` creates the empty template; after that, only `refine`, the stakeholder step of `review`, and the E2E setup in `.claude/skills/qa/e2e.md` (§6 Test / Operate) change it, and only from the developer's answers.

Spec file: the given file, else the only `.md` in `Spec/` (excluding `review/`), else ask which one. Dates are `YYYY-MM-DD` (today). `{title}` is the spec's file name without `.md`. If the output file already exists, append `-2`, `-3`, ... Write reports in the spec's language.

## setup [title]

1. Title defaults to `app`. Use kebab-case for the file name.
2. Copy `templates/spec.md` (next to this file) to `Spec/{title}.md`, replacing `{{title}}` with the title. Never overwrite an existing file. If an earlier spec exists, do not copy anything from it; the developer decides what carries over.
3. Tell the user: the spec is theirs to write, `/persona new` creates the stakeholders it names, and to run `/spec refine` and `/spec review` when ready. Nothing else.

## review [file]

1. Read the spec. If most sections still contain only their `<!-- hint -->`, stop and tell the user which sections to fill in first.
2. **Stakeholders**: read §3. If it names no persona, or names one whose file is missing in `Docs/Personas/`:
   - Ask in one AskUserQuestion call which stakeholders this spec is for, offering the existing `Docs/Personas/` files (multi-select) and "a new one". Add the chosen links to §3 exactly as answered.
   - For each new one, follow `.claude/skills/persona/SKILL.md` (`new`), then add its link to §3.
   - The developer may decline stakeholders for this review; then continue with the core reviewers only and say so in the report.
3. Reviewers: every file in `.claude/personas/`, plus every persona file linked in §3. Launch one `persona-reviewer` agent per reviewer, **in parallel, in one message**. The prompts are identical except for the persona file: the persona file path, "Mode: spec review", the spec path, the report language, and the per-reviewer section of `templates/review.md` (from `## {{Reviewer}}` to the end) as the format to return. Do not add your own opinions or hints to the prompt, and never pass one reviewer's output to another.
4. Write `Spec/review/{date}-{title}.md` from `templates/review.md`:
   - Reviewer sections go in **exactly as returned**.
   - Summary, "Raised by more than one reviewer", "Where reviewers disagree", and "Questions for the author" are built only from the reviewer sections. Add nothing of your own.
5. Do not touch the spec beyond step 2. In chat, show the summary table and the report path.

## refine [file]

This is about wording only. Reviewers' "Questions for the author" ask for new content, so the developer answers those by writing in the spec themselves.

1. Read the spec.
2. Find wording problems. Each one quotes the exact text:
   - **unclear**: vague words ("easy", "fast", "some", "etc."), undefined terms, a rule with no number where one is needed, a scenario whose Then is not observable or whose When holds several actions
   - **redundant**: the same thing said twice, or in two different ways
   - **contradiction**: two statements that cannot both be true (including a scenario that contradicts the core logic)
   - Empty sections, and scenarios missing "Why I expect this": list them in the final message. Do not ask the user to fill them here.
3. Ask with AskUserQuestion, at most 4 questions per call, most important first. Quote the text with its section or scenario. Options are possible readings of what the developer wrote (for redundant: keep A / keep B / merge), never new ideas. The developer can always answer in their own words.
4. Edit the spec using only the answers, keeping the developer's words and tone. Change only the quoted passages. Update "Last updated".
5. Report one line per change: `§n: "before" → "after"`. Then list empty sections, if any.

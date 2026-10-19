---
name: persona
description: Create a stakeholder user persona in Docs/Personas/ by interviewing the developer and recording their answers in their own words. "/persona new [name]" creates one, "/persona list" lists them. /spec review and /qa follow this skill when a spec names a stakeholder whose file is missing.
disable-model-invocation: true
argument-hint: "new [name] | list"
---

# Persona

Arguments: $ARGUMENTS. No mode → `new`.

**The developer writes the persona.** You ask; they answer; you record their answers in their words. Never invent traits, quotes, numbers, or behaviors. A section the developer leaves unanswered stays as its `<!-- hint -->`.

## list

List each file in `Docs/Personas/` (except `README.md`) with its one-line **Who**, and the specs in `Docs/Spec/` that name it in their Stakeholders section.

## new [name]

1. Name defaults to asking the developer. File: `Docs/Personas/{kebab-case name}.md`. Never overwrite an existing file; if it exists, show it and stop. Changes to an existing persona go to `Proposal/` (`.claude/guides/proposal.md`), never into the file.
2. If a spec exists, read its Pitch and Stakeholders sections so your questions fit the app. Do not answer them yourself.
3. Interview with AskUserQuestion, at most 4 questions per call, in this order. Questions are open; options, if any, are only readings of what the developer already said, never suggested traits.
   1. **Who**: who this person is, in one line (role, not a made-up name).
   2. **Context**: where, on what device, how often, how expert with this domain and with software.
   3. **Goals**: what they are trying to get done, and why it matters to them.
   4. **Tasks**: which things they would do with this app, in their order.
   5. **How they use it**: habits and shortcuts, typical mistakes, things they do that the designer would not expect.
   6. **Breaking points**: what makes them frustrated, distrust the app, or quit.
   If an answer is vague ("normal user", "anything"), ask again about that answer only.
4. Write the file from `template.md` (next to this file), placing answers verbatim. Fill **Last updated** and **Written by** (the developer's name if known).
5. Report the path and any sections left empty. Suggest naming it in a spec's Stakeholders section.

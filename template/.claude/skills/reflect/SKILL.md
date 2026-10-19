---
name: reflect
description: After a prototype or QA run, interview the developer about what the results mean and what happens next, and record their answers in Docs/Decisions/{date}-{title}.md. Claude asks and records; the developer concludes.
disable-model-invocation: true
argument-hint: "[QA report or scenario IDs]"
---

# Reflect

Request: $ARGUMENTS

**The developer draws the conclusions.** Never state whether a prediction held, what a result means, or what to do next. Record answers in the developer's words.

1. **Material**: the given QA report, else the newest in `QA/`, else the last `/prototype` report in this conversation. Read it and the spec. `{title}` is the QA report's title, else the spec's.
2. **Show the facts** in chat, no interpretation: the scenario table (the developer's Then vs. observed), failing tests, and each reviewer's verdict and top issue.
3. **Interview** with AskUserQuestion, at most 4 questions per call, in this order. Open questions; options only as readings of what the developer already said or wrote.
   1. **Predictions**: for each in-scope scenario, did it behave as you expected? Where it did not, was your "Why I expect this" wrong, or the build?
   2. **Surprises**: what did you learn that you did not expect?
   3. **Reviewer points**: which ones do you accept, and which do you reject, and why? (Ask about the ones raised by more than one reviewer, the disagreements, and every blocker; the developer can add others.)
   4. **Contribution**: does this support, weaken, or not yet speak to the spec's contribution (§2)?
   5. **Decision**: drop the idea, iterate on it, take it further, or change the framework, and why.
   6. **Next**: which spec sections you will change, and the next step.
   If an answer is vague ("it's fine", "mostly"), ask again about that answer only.
4. Write `Docs/Decisions/{date}-{title}.md` from `template.md` (next to this file), placing answers verbatim. If the file exists, append `-2`, `-3`, ...
5. **Follow-ups, listed, never done**: spec sections the developer said they will change (they edit them, or run `/spec refine`). If the decision changes the framework or accepts a reviewer's reframe: "update §6 (framework) or §4 (if the explanation changes), then run `/restructure`".

Report the path and the follow-up list.

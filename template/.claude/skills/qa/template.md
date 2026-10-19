# QA: {{title}}

- Date: {{YYYY-MM-DD}}
- Spec: [{{spec file}}](../Spec/{{spec file}})
- Build: {{git short hash, or "not in git"}}
- Scope: {{scenario IDs}}, {{start}} → {{end}}
- Purpose: {{purpose}}
- Pass if: {{criterion}}
- Parts run: {{test / code review / use review}}
- Reviewers: {{core persona titles}}; stakeholders: {{stakeholder persona names}}. Each evaluated independently and did not see the others' evaluations.
- Persona reviews are simulated, not user-study evidence.

## Result

**{{Pass / Pass with issues / Fail}}** against "Pass if": {{one line, citing the test or step that shows it}}

## Scenarios

| Scenario | Expected (developer's Then) | Test | Observed in sessions |
|---|---|---|---|
| {{S1}} | | {{pass / fail / none}} | {{what happened, with capture link}} |

## Tests

[test.md](./{{date}}-{{title}}/test.md): {{N passed, M failed}}. Failing:

| Test | Scenario | Failure |
|---|---|---|
| | | |

## Bugs

{{Reproducible defects only. Taste and design go in the reviewer sections.}}

| # | Severity | Where | What happened | Expected | Evidence |
|---|---|---|---|---|---|
| 1 | {{blocker / major / minor}} | {{test, persona step, or file:line}} | | | {{capture, log line, or test}} |

## Reviewers

| Reviewer | Verdict | Top issue |
|---|---|---|
| {{persona title}} | | |

## Raised by more than one reviewer

{{One line each, naming who raised it.}}

## Where reviewers disagree

{{One line per side. The developer decides.}}

## Sessions

{{One block per persona, in reviewer order. Every step has its capture.}}

### {{persona}}

[evidence.md](./{{date}}-{{title}}/{{persona}}/evidence.md)

{{Step n: action. ![what the capture shows](./{{date}}-{{title}}/{{persona}}/{{NN-step}}.png) One or two sentences: expected vs. what happened.}}

## Not covered

{{What this run could not test and how to test it (for example, a real user study for anything the contribution claims about people).}}

---

{{One section per reviewer, in the order of the reviewer table, pasted exactly as the reviewer returned it:}}

## {{Reviewer}}

**Verdict**: {{Pass / Pass with issues / Fail}}, {{one-line reason}}

**Notes** {{only what the persona's lens asks for that does not fit a table, such as a core-logic-to-code map; else omit}}

**Code findings** {{omit if the persona has no code lens}}

| # | Severity | Location | Finding | Suggestion |
|---|---|---|---|---|
| 1 | {{blocker / major / minor}} | {{file:line}} | | |

**Use findings**

| # | Severity | Step | Finding | Evidence | Suggestion |
|---|---|---|---|---|---|
| 1 | {{blocker / major / minor}} | {{n}} | | {{capture or log line}} | |

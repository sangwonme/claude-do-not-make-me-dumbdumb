# Spec review: {{spec title}}

- Spec: [{{spec file}}](../{{spec file}})
- Spec version: {{git short hash, or last-modified time if not in git}}
- Date: {{YYYY-MM-DD}}
- Reviewers: {{core persona titles}}; stakeholders: {{stakeholder persona names}}. Each reviewed independently and did not see the others' reviews.
- These are simulated persona reviews, not user-study evidence.

## Summary

| Reviewer | Verdict | Top concern |
|---|---|---|
| {{persona title}} | | |

{{One row per persona.}}

Verdicts: **Go** (build it), **Revise** (fix the issues first), **Rethink** (the core idea needs work).

## Raised by more than one reviewer

{{The same issue from 2+ reviewers, strongest signal first. One line each, naming who raised it.}}

## Where reviewers disagree

{{One line per side. The developer decides; do not resolve it here.}}

## Questions for the author

{{Merged and deduplicated from all reviewers, each with its spec section. The developer answers these by editing the spec.}}

---

{{One section per reviewer, in the order of the summary table, pasted exactly as the reviewer returned it:}}

## {{Reviewer}}

**Verdict**: {{Go / Revise / Rethink}}, {{one-line reason}}

**Strengths**
- {{§n or Sn: what works and why}}

**Issues**

| # | Severity | Where | Issue | Suggestion |
|---|---|---|---|---|
| 1 | {{blocker / major / minor}} | {{§n or Sn}} | | |

**Questions for the author**
- {{§n or Sn: question}}

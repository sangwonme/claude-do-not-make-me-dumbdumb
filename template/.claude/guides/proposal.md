# Proposal format

Claude never edits a developer doc (see `CLAUDE.md`). Every change it would make is written here instead, one file per target doc and topic: `proposal/{YYYY-MM-DD}-{doc name}-{topic}.md`. If it exists, append `-2`, `-3`, ...

```markdown
# Proposal: {topic}

- Target: [{doc path}]({relative link})
- From: {the skill or request that produced it, e.g. "/spec refine", "/spec review stakeholders", "environment setup"}
- Date: {YYYY-MM-DD}

> Apply by hand. Claude does not apply proposals.

## Changes

### 1. {§n or section name}

Current:
> {exact current text, or "(empty)"}

Proposed:
> {exact replacement text}

Why: {one line: the developer's answer it comes from, quoted, or the reason}
```

Rules:
- Every proposed text comes from the developer's own answers or words. A proposal never carries Claude's ideas into a developer doc.
- Quote current text exactly, so the developer can find it.
- In chat, list the proposal path and one line per change.

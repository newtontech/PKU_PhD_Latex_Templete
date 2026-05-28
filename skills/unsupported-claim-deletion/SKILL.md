---
name: unsupported-claim-deletion
description: Identify and propose deletion or weakening of MISSING and CONTRADICTED claims from the claim-evidence matrix. Generate exact LaTeX locations and edit proposals. Use after claim-evidence-map to clean unsupported assertions.
argument-hint: [claim-evidence-matrix-path]
---

# Unsupported Claim Deletion

Identify claims in the manuscript that lack supporting evidence or are contradicted by available data, and produce actionable edit proposals to remove, weaken, or flag them.

## When to Use

- After running `claim-evidence-map` and producing a `claim_evidence_matrix.csv`.
- Before submission when the manuscript may contain assertions not backed by experimental results.
- During revision when reviewers question specific claims and you need a systematic audit.
- When consolidating multiple draft versions that may have introduced unverified statements.

## Input

- **Required**: Path to a `claim_evidence_matrix.csv` file (produced by `claim-evidence-map`).
- The CSV must contain at minimum the columns: `claim_id`, `claim_text`, `evidence_status`, `evidence_source`.
- **Optional**: Path to the LaTeX project root directory (defaults to the directory containing the CSV if omitted).

## Workflow

1. **Parse the matrix**. Read `claim_evidence_matrix.csv` and filter rows where `evidence_status` is `MISSING` or `CONTRICTED`. Ignore `SUPPORTED` and `PARTIAL` rows.

2. **Locate each claim in LaTeX**. For each filtered claim:
   - Search the `.tex` files for the exact `claim_text` or a sufficiently unique substring (minimum 8 words).
   - Record the file path, line number, and surrounding context (3 lines before and after).
   - If the exact text is not found, search for paraphrased variants using keyword extraction from the claim.

3. **Classify the proposed action**. For each unsupported claim, assign one of the following actions:
   - **DELETE**: The claim is tangential, redundant, or cannot be salvaged. Remove the sentence entirely.
   - **WEAKEN**: The claim direction is plausible but unproven. Replace strong language with hedged forms: "may", "could", "suggests", "it is possible that", "preliminary results indicate".
   - **MOVE_TO_LIMITATIONS**: The claim reveals a known gap. Move it to a Limitations or Future Work section, reframed as an open question.
   - **ADD_TODO**: The claim is important and evidence likely exists but was not linked. Insert a LaTeX comment `% TODO: add evidence for ...` so the author can address it manually.

4. **Generate proposed text**. For WEAKEN actions, produce the rewritten sentence. For MOVE_TO_LIMITATIONS, produce the reframed sentence. For DELETE, note the surrounding text that needs adjustment (e.g., merging adjacent sentences). For ADD_TODO, produce the TODO comment.

5. **Sort edits by location**. Order the proposed edits by file and line number so they can be applied top-to-bottom without line-number drift.

6. **Write outputs** (see Output section).

## Output

### `unsupported_claims.md`

A markdown table and detailed report with one entry per unsupported claim:

```markdown
## Unsupported Claims Report

| # | Claim ID | File | Line | Action | Rationale |
|---|----------|------|------|--------|-----------|
| 1 | C03 | results.tex | 142 | WEAKEN | No data supports causal statement |

### Detail: C03
- **Location**: `chapter4/results.tex` line 142
- **Current text**: "X significantly improves Y under all conditions."
- **Proposed text**: "X may improve Y under certain conditions, though further validation is needed."
- **Proposed action**: WEAKEN
- **Rationale**: The claim-evidence matrix shows MISSING status. No experimental data in the project links X to Y improvement.
```

### `latex_revision_plan.md`

An ordered list of edit operations for batch application:

```markdown
## LaTeX Revision Plan (Ordered by Location)

### Edit 1 — WEAKEN
- **File**: `chapter4/results.tex`
- **Line**: 142
- **Find**: "X significantly improves Y under all conditions."
- **Replace**: "X may improve Y under certain conditions, though further validation is needed."

### Edit 2 — DELETE
- **File**: `chapter5/discussion.tex`
- **Line**: 87
- **Find**: "This proves that the mechanism is universally applicable."
- **Replace**: (delete sentence; merge preceding and following sentences)

### Edit 3 — ADD_TODO
- **File**: `chapter3/methods.tex`
- **Line**: 54
- **Find**: "The calibration error is negligible."
- **Replace**: "The calibration error is negligible. % TODO: add calibration measurement data as evidence"
```

## Rules

- **Never strengthen a weak claim.** If a claim is MISSING or CONTRADICTED, do not propose language that makes the assertion stronger than the original.
- **Preserve author voice.** When weakening claims, match the surrounding prose style and vocabulary.
- **Respect LaTeX structure.** Edits must not break `\label{}`, `\ref{}`, `\cite{}`, or equation environments.
- **Report unlocatable claims.** If a claim from the matrix cannot be found in any `.tex` file, list it separately under "Unresolved Claims" in the report rather than silently dropping it.
- **No partial edits.** Each proposed edit must be a complete, syntactically valid replacement (not a fragment).
- **Line numbers are approximate.** Always use text-based matching (find/replace) rather than relying solely on line numbers, since line numbers shift after edits.

## Related Skills

- **claim-evidence-map**: Produces the input matrix for this skill. Run it first.
- **paper-revision-orchestrator**: Can consume `latex_revision_plan.md` as part of a broader revision workflow.
- **citation-verification-gate**: Use alongside this skill to also audit citation support for remaining claims.
- **results-consistency**: Cross-checks that numerical results in text match source data.

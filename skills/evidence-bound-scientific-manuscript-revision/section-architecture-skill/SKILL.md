---
name: section-architecture-skill
description: Reorganize scientific manuscript sections according to IMRaD, thesis, or target-journal structure while preserving evidence-bound claims, labels, citations, equations, and figure/table references. Use after claim and result audits have established what the evidence supports.
---

# Section Architecture Skill

Use this skill to improve manuscript structure without changing unsupported scientific content. It works after the claim-evidence matrix exists.

## Inputs

- Manuscript source files.
- Claim-evidence matrix.
- Results consistency audit.
- Optional target journal, thesis format, page budget, or reviewer comments.

## Allowed Work

- Reorder sections or paragraphs when the evidence chain remains intact.
- Separate background, methods, results, discussion, and limitations.
- Recommend main-text versus supplementary placement.
- Convert topic headings into claim-oriented headings when supported.
- Identify duplicated paragraphs and misplaced details.
- Propose section openers that summarize verified content.

## Disallowed Work

- Do not invent new results, experiments, mechanisms, or citations.
- Do not strengthen `WEAKLY_SUPPORTED` claims.
- Do not hide limitations to improve narrative.
- Do not change LaTeX labels, equation labels, citation keys, or figure/table references unless the diff explains why.

## Section Move Plan

Output `section_move_plan.md` with:

| Field | Meaning |
| --- | --- |
| `move_id` | Stable ID such as `S001` |
| `source_location` | Original file and section |
| `target_location` | Proposed destination |
| `move_type` | reorder, merge, split, move_to_SI, promote_to_main, delete_duplicate, rename_heading |
| `claim_ids` | Claims affected by the move |
| `evidence_status` | Highest-risk evidence status among affected claims |
| `rationale` | Why the move improves argument flow |
| `requires_author_approval` | yes or no |

## Architecture Checks

- Abstract promises only claims supported in the body.
- Introduction contribution list matches verified results and methods.
- Methods appear before results when needed for comprehension.
- Each results subsection has a supported takeaway.
- Discussion separates interpretation, limitations, and speculation.
- Conclusion restates verified contributions without new claims.
- Supplementary placement does not remove evidence needed for main claims.

## Output Modes

- `plan-only`: produce the section move plan without editing.
- `patch`: produce minimal LaTeX or Markdown edits.
- `commentary`: annotate DOCX or extracted text with proposed moves.

Default to `plan-only` unless the user asks for edits.

## Completion Check

The final plan must list every structural change, affected claims, evidence risks, and author decisions. If a change would alter scientific meaning, mark it as `NEEDS_HUMAN_DECISION`.

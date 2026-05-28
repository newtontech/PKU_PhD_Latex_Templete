---
name: claim-evidence-map-skill
description: Map manuscript claims to concrete evidence from experiment files, figures, tables, code outputs, logs, supplementary material, author notes, or verified references. Use before revising scientific claims, novelty statements, abstracts, conclusions, captions, or reviewer responses.
---

# Claim Evidence Map Skill

Use this skill to create a claim-evidence matrix. It protects the manuscript from unsupported additions, overclaims, and citation drift.

## Inputs

- Manuscript files or extracted text.
- `project_file_inventory.md` from `project-file-map-skill`.
- Optional target sections: abstract, introduction, results, discussion, conclusion, captions, reviewer response.
- Optional verified bibliography or DOI list.

## Claim Types

Extract claims that affect scientific meaning:

- Contribution and novelty claims.
- Quantitative results.
- Comparative performance claims.
- Mechanism or causal claims.
- Dataset, experimental setup, and method claims.
- Figure/table takeaway claims.
- Literature positioning claims.
- Limitation and future-work claims.

Ignore purely stylistic wording unless it changes meaning.

## Matrix Schema

Output `claim_evidence_matrix.csv` or a Markdown table with:

| Field | Meaning |
| --- | --- |
| `claim_id` | Stable ID such as `C001` |
| `location` | File, section, paragraph, line, caption, or response item |
| `claim_text` | The claim as written or summarized |
| `claim_type` | novelty, quantitative, comparative, method, mechanism, limitation, citation, caption, other |
| `evidence_ids` | File IDs, figure IDs, table IDs, DOI IDs, manuscript source IDs, or author note source IDs |
| `author_decision_id` | Optional decision ID for scope, strategy, confidential context, or unresolved judgment |
| `support_level` | VERIFIED, WEAKLY_SUPPORTED, MISSING, CONTRADICTED, NEEDS_HUMAN_DECISION |
| `risk` | low, medium, high |
| `recommended_action` | keep, weaken, delete, move_to_limitation, add_evidence, ask_author |
| `notes` | Short rationale |

## Support Rules

- `VERIFIED`: direct source supports the claim at the same strength.
- `WEAKLY_SUPPORTED`: source supports a weaker version or adjacent claim only.
- `MISSING`: no source found.
- `CONTRADICTED`: source gives a different number, direction, mechanism, or scope.
- `NEEDS_HUMAN_DECISION`: source exists but scientific framing or confidential context decides the wording.
- Author decisions can approve scope or strategy, but they cannot replace source evidence for factual scientific claims.

## Revision Guidance

- Preserve `VERIFIED` claims, but improve clarity if needed.
- Weaken `WEAKLY_SUPPORTED` claims by narrowing scope, adding conditions, or moving them to limitations.
- Remove or TODO `MISSING` claims.
- Block on `CONTRADICTED` claims until the source or manuscript is corrected.
- Do not create new claims while trying to fix old ones.

## Completion Check

The matrix must cover all headline claims in the abstract, introduction contributions, results takeaways, captions, and conclusion. Any high-risk claim without direct evidence must appear in `unsupported_claims.md`.

# Revision Workflow Guide

## Pipeline Overview

```
Index Experiments ──→ File Map ──→ Evidence Map ──→ Consistency Check
                                                       │
                                                       ▼
                                         Verify Evidence ──→ Verify Citations
                                                       │
                                                       ▼
                                    Delete Unsupported ──→ Structure ──→ Methods
                                                       │
                                                       ▼
                                    Style Check ──→ Autorater ──→ Multi-Review
                                                       │
                                                       ▼
                                    Diff ──→ Redline ──→ Submission QA ──→ Compile
```

## Phase 1: Evidence Collection
1. `experiment-folder-indexer` — Build evidence ledger from experiment files
2. `project-file-map` — Inventory all manuscript, figure, data, and reference files

## Phase 2: Evidence Binding
3. `claim-evidence-map` — Map claims to evidence with support levels
4. `results-consistency` — Check numerical and cross-reference consistency
5. `paper-evidence-verifier` — Verify evidence chains are not broken

## Phase 3: Content Revision
6. `citation-verification-gate` — Validate all citations and references
7. `unsupported-claim-deletion` — Remove or weaken unsupported claims
8. `section-architecture` — Reorganize structure (plan-only first)
9. `methods-reproducibility` — Fill method gaps from evidence only

## Phase 4: Quality Assurance
10. `materials-science-style` — Domain-specific style check
11. `manuscript-autorater` — Score quality on 6 axes
12. `multi-reviewer-audit` — 5-perspective peer review simulation

## Phase 5: Output & Submission
13. `latex-docx-diff` — Generate reviewable diff
14. `paper-redline-diff` — Generate redline PDF
15. `submission-qa-gate` — Final pre-submission checklist
16. `paper-compilation` — Compile final PDF

## Orchestrator

`paper-revision-orchestrator` coordinates the full pipeline. Run `/revise` to use it.

## Parallelization

After file map exists:
- `claim-evidence-map`, `results-consistency`, `methods-reproducibility` can run in parallel
- `section-architecture` waits for evidence + consistency reports
- `latex-docx-diff` waits for all accepted edits

## Checkpoints

- After Phase 2: resolve all CONTRADICTED claims before proceeding
- After Phase 3: run autorater, stop if score drops from previous round
- After Phase 4: address all CRITICAL issues from multi-reviewer
- Before Phase 5: resolve all blocker-level findings

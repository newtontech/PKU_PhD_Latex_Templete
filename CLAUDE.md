# CLAUDE.md — Claude Code Integration

This is a PKU PhD thesis LaTeX template with an integrated evidence-bound revision skill pack.

## Project Type

- **LaTeX thesis template** for Peking University College of Engineering
- Main file: `COEmain.tex` (ctexbook, XeLaTeX required)
- Sections: `preface/`, `body/`, `appendix/`, `figures/`, `setup/`

## Compile Commands

```bash
xelatex COEmain.tex && bibtex COEmain && xelatex COEmain.tex && xelatex COEmain.tex
```

## How to Use Skills

All skills are in `skills/<skill-name>/SKILL.md`. When the user asks for a revision task, read the corresponding SKILL.md and follow its instructions.

| User asks to... | Read this skill |
|-----------------|----------------|
| Run full revision pipeline | `skills/paper-revision-orchestrator/SKILL.md` |
| Compile LaTeX / fix build errors | `skills/paper-compilation/SKILL.md` |
| Inventory all project files | `skills/project-file-map/SKILL.md` |
| Map claims to evidence | `skills/claim-evidence-map/SKILL.md` |
| Check number/figure/table consistency | `skills/results-consistency/SKILL.md` |
| Verify evidence chains | `skills/paper-evidence-verifier/SKILL.md` |
| Validate citations and references | `skills/citation-verification-gate/SKILL.md` |
| Remove unsupported claims | `skills/unsupported-claim-deletion/SKILL.md` |
| Reorganize sections | `skills/section-architecture/SKILL.md` |
| Audit methods reproducibility | `skills/methods-reproducibility/SKILL.md` |
| Generate reviewable diffs | `skills/latex-docx-diff/SKILL.md` |
| Generate redline PDF | `skills/paper-redline-diff/SKILL.md` |
| Build evidence ledger from experiments | `skills/experiment-folder-indexer/SKILL.md` |
| Consolidate experiment logs | `skills/experiment-log-aggregator/SKILL.md` |
| Reorganize LaTeX file structure | `skills/latex-structure-refactor/SKILL.md` |
| Check materials science style | `skills/materials-science-style/SKILL.md` |
| Score manuscript quality | `skills/manuscript-autorater/SKILL.md` |
| Simulate peer review | `skills/multi-reviewer-audit/SKILL.md` |
| Pre-submission checklist | `skills/submission-qa-gate/SKILL.md` |

Full skill catalog: `skills/README.md`

## Non-Negotiable Rules

- **Never** invent experiments, datasets, baselines, numerical results, ablations, mechanisms, citations, or limitations
- **Only** add scientific content supported by manuscript text, evidence files, verified references, or explicit author notes
- **Preserve** LaTeX labels, citations, equations, cross-references, and figure/table references unless a change is explicitly justified
- For uncertain edits, leave **TODO** comments or decision items
- Every changed factual claim must have a **source evidence ID**

## Evidence Status

| Status | Meaning | Action |
|--------|---------|--------|
| `VERIFIED` | Direct evidence support | Can write into manuscript |
| `WEAKLY_SUPPORTED` | Indirect/incomplete support | Lower claim strength |
| `MISSING` | No evidence found | TODO only, do not add |
| `CONTRADICTED` | Evidence conflicts | Block until resolved |
| `NEEDS_HUMAN_DECISION` | Scientific judgment needed | Present options, don't decide |

## Recommended Revision Workflow

```
1.  experiment-folder-indexer    → Build evidence ledger
2.  project-file-map             → Inventory all files
3.  claim-evidence-map           → Map claims to evidence
4.  results-consistency          → Check numerical consistency
5.  paper-evidence-verifier      → Verify evidence chains
6.  citation-verification-gate   → Check references
7.  unsupported-claim-deletion   → Remove unsupported claims
8.  section-architecture         → Reorganize sections
9.  methods-reproducibility      → Audit reproducibility
10. materials-science-style      → Domain conventions
11. manuscript-autorater         → Score current quality
12. multi-reviewer-audit         → Peer review simulation
13. latex-docx-diff              → Generate reviewable diff
14. paper-redline-diff           → Generate redline PDF
15. submission-qa-gate           → Final submission check
16. paper-compilation            → Compile final PDF
```

Or use `paper-revision-orchestrator` to coordinate the full pipeline.

## LaTeX Template Specifics

See `AGENTS.md` for detailed formatting rules. Key points:

- Document class: `ctexbook` with 12pt, a4paper, openany, twoside
- Font: 小四 (12pt) body, 三号 黑体 chapter headings
- Bibliography: `gbt7714-numerical` style (GB/T 7714-2015)
- Line spacing: 1.5x (set via `\renewcommand{\baselinestretch}{1}`)
- Page margins: top 25mm, bottom 25mm, left 30mm, right 20mm

## Reference

- LaTeX formatting details: `AGENTS.md`
- Graph/equation rules: `body/graph_and_equation.AGENTS.md`
- Style definitions: `body/style.AGENTS.md`
- Skill catalog: `skills/README.md`
- Evidence status guide: `skills/shared/references/evidence-status-guide.md`
- Revision workflow: `skills/shared/references/revision-workflow.md`

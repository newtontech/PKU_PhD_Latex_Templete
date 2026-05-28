# Skill Catalog

Evidence-bound scientific manuscript revision skills for LaTeX theses.

## Quick Reference

| Skill | Slash Command | Purpose |
|-------|--------------|---------|
| [paper-revision-orchestrator](paper-revision-orchestrator/SKILL.md) | `/revise` | Top-level revision coordinator |
| [paper-compilation](paper-compilation/SKILL.md) | `/compile` | Compile LaTeX, fix errors |
| [project-file-map](project-file-map/SKILL.md) | `/file-map` | Inventory all project files |
| [claim-evidence-map](claim-evidence-map/SKILL.md) | `/evidence-map` | Map claims to evidence |
| [results-consistency](results-consistency/SKILL.md) | `/consistency` | Check number/figure/table consistency |
| [section-architecture](section-architecture/SKILL.md) | `/structure` | Reorganize sections |
| [methods-reproducibility](methods-reproducibility/SKILL.md) | `/methods` | Audit methods completeness |
| [latex-docx-diff](latex-docx-diff/SKILL.md) | `/diff` | Generate reviewable diffs |
| [paper-evidence-verifier](paper-evidence-verifier/SKILL.md) | `/verify-evidence` | Verify evidence chains |
| [citation-verification-gate](citation-verification-gate/SKILL.md) | `/verify-citations` | Check citations and refs |
| [paper-redline-diff](paper-redline-diff/SKILL.md) | `/redline` | Redline PDF for review |
| [experiment-folder-indexer](experiment-folder-indexer/SKILL.md) | `/index-experiments` | Build evidence ledger |
| [unsupported-claim-deletion](unsupported-claim-deletion/SKILL.md) | `/delete-unsupported` | Remove unsupported claims |
| [latex-structure-refactor](latex-structure-refactor/SKILL.md) | `/refactor-latex` | Reorganize LaTeX files |
| [materials-science-style](materials-science-style/SKILL.md) | `/style-check` | Domain style conventions |
| [experiment-log-aggregator](experiment-log-aggregator/SKILL.md) | `/aggregate-logs` | Consolidate experiment records |
| [manuscript-autorater](manuscript-autorater/SKILL.md) | `/autorater` | Score manuscript quality |
| [multi-reviewer-audit](multi-reviewer-audit/SKILL.md) | `/multi-review` | 5-perspective peer review |
| [submission-qa-gate](submission-qa-gate/SKILL.md) | `/submission-qa` | Pre-submission checklist |

## Categories

### Core Pipeline
Skills that form the mandatory revision pipeline:

1. **experiment-folder-indexer** — Build evidence ledger from experiment files
2. **project-file-map** — Discover and inventory all files
3. **claim-evidence-map** — Extract claims, bind to evidence IDs
4. **results-consistency** — Audit numbers, figures, tables
5. **paper-evidence-verifier** — Verify evidence chains are intact
6. **unsupported-claim-deletion** — Remove or weaken unsupported claims
7. **section-architecture** — Reorganize structure
8. **methods-reproducibility** — Fill method gaps from evidence
9. **paper-revision-orchestrator** — Coordinate all of the above

### Quality Assurance
Skills for checking and scoring:

- **citation-verification-gate** — Validate all citations
- **materials-science-style** — Domain-specific style check
- **manuscript-autorater** — 6-axis quality scoring
- **multi-reviewer-audit** — 5-perspective peer review
- **submission-qa-gate** — Final pre-submission checklist

### Output Generation
Skills for producing reviewable artifacts:

- **latex-docx-diff** — Reviewable diff generation
- **paper-redline-diff** — Redline PDF for advisor review
- **paper-compilation** — Compile final PDF

### Infrastructure
Supporting skills and resources:

- **experiment-log-aggregator** — Consolidate scattered experiment records
- **latex-structure-refactor** — Reorganize LaTeX file structure
- [shared/](shared/) — Schemas, templates, reference documents

## Skill Format

Each skill directory contains a `SKILL.md` with:

```yaml
---
name: skill-name
description: What the skill does and when to use it
argument-hint: [expected-input]
---
```

Followed by Markdown sections: When to Use, Input, Workflow, Output, Rules, Related Skills.

## Design Principles

1. **Evidence-bound**: Every scientific claim must map to real evidence
2. **Small skills**: Each skill solves one problem; orchestrator coordinates
3. **Human decision points**: Uncertain edits become TODO items
4. **Reviewable output**: All edits traceable via diffs and evidence IDs
5. **No fabrication**: Never invent data, results, citations, or experiments

## Shared Resources

- [evidence-status-guide.md](shared/references/evidence-status-guide.md) — Evidence status definitions
- [revision-workflow.md](shared/references/revision-workflow.md) — Full pipeline guide
- [output-schemas.md](shared/schemas/output-schemas.md) — Expected output formats
- [experiment-log-template.md](shared/templates/experiment-log-template.md) — Experiment log template

## Source Projects

This skill pack draws patterns from:

| Project | What We Borrow |
|---------|---------------|
| [Research-Equality/RE-paper-writing](https://github.com/Research-Equality/RE-paper-writing) | SKILL.md format, skill catalog organization, compilation/diff/verification patterns |
| [Ar9av/PaperOrchestra](https://github.com/Ar9av/PaperOrchestra) | 4-phase experiment aggregation, 6-axis autorater scoring, halt rules |
| [Imbad0202/academic-research-skills](https://github.com/Imbad0202/academic-research-skills) | 5-perspective multi-reviewer, Material Passport handoff, checkpoint pipeline |

This repository only borrows workflow patterns and design ideas. It does not copy upstream source code, scripts, or agent configurations. All academic content responsibility remains with the thesis author.

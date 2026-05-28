# PKU PhD LaTeX Template with Evidence-Bound Revision Skills

北京大学工学院博士学位论文 LaTeX 模板，集成学术规范修订 Skill Pack。

A PKU College of Engineering PhD thesis LaTeX template with an integrated evidence-bound revision skill pack for Claude Code and Codex.

## Quick Start

```bash
git clone <repository_url>
cd PKU_PhD_Latex_Templete

# Compile thesis
xelatex COEmain.tex && bibtex COEmain && xelatex COEmain.tex && xelatex COEmain.tex
```

Skills are self-discovering — Claude Code reads `CLAUDE.md` on startup, which maps user requests to `skills/*/SKILL.md`. No setup script needed.

## Project Structure

```
PKU_PhD_Latex_Templete/
├── COEmain.tex                    # Main thesis file (ctexbook)
├── CLAUDE.md                      # Claude Code instructions + skill routing
├── AGENTS.md                      # Codex + LaTeX formatting guide
│
├── preface/                       # Cover, abstract
├── body/                          # Chapters, bibliography
├── appendix/                      # Publications, acknowledgements
├── figures/                       # Images
├── setup/                         # LaTeX format and package settings
│
├── skills/                        # 19 revision skills
│   ├── README.md                  # Skill catalog
│   ├── paper-revision-orchestrator/
│   ├── paper-compilation/
│   ├── ... (see skills/README.md)
│   └── shared/                    # Schemas, templates, references
│
├── .claude/settings.local.json    # Claude Code permissions
├── .codex/AGENTS.md               # Codex integration (symlink)
└── revision_outputs/              # Revision artifacts output
```

## Branches

- **`main`**: Complete thesis template with all personal information
- **`double-blind`**: Anonymized version for blind review (no acknowledgements, publications, or identifying info)

## Dual-Agent Support

| Feature | Claude Code | Codex |
|---------|------------|-------|
| Instructions | `CLAUDE.md` | `AGENTS.md` |
| Skills | `skills/*/SKILL.md` (routed via CLAUDE.md) | `skills/*/SKILL.md` |
| Configuration | `.claude/settings.local.json` | `.codex/AGENTS.md` |

## Available Skills

### Core Pipeline
| Skill | Purpose |
|-------|---------|
| paper-revision-orchestrator | Top-level revision coordinator |
| project-file-map | Inventory all project files |
| claim-evidence-map | Map claims to evidence |
| results-consistency | Check numerical consistency |
| paper-evidence-verifier | Verify evidence chains |

### Quality Assurance
| Skill | Purpose |
|-------|---------|
| citation-verification-gate | Validate all citations |
| unsupported-claim-deletion | Remove unsupported claims |
| methods-reproducibility | Audit reproducibility |
| materials-science-style | Domain style conventions |
| manuscript-autorater | 6-axis quality scoring |
| multi-reviewer-audit | 5-perspective peer review |
| submission-qa-gate | Pre-submission checklist |

### Output & Compilation
| Skill | Purpose |
|-------|---------|
| paper-compilation | Compile LaTeX, fix errors |
| latex-docx-diff | Generate reviewable diffs |
| paper-redline-diff | Redline PDF for review |

### Infrastructure
| Skill | Purpose |
|-------|---------|
| experiment-folder-indexer | Build evidence ledger |
| experiment-log-aggregator | Consolidate experiment records |
| latex-structure-refactor | Reorganize LaTeX structure |

## Design Principles

1. **Evidence-bound**: Every scientific claim maps to real experiment evidence
2. **No fabrication**: Never invent data, results, citations, or experiments
3. **Human decision points**: Uncertain edits become TODO items, not silent rewrites
4. **Reviewable output**: All edits traceable via diffs and evidence IDs
5. **Small composable skills**: Each skill solves one problem; orchestrator coordinates

## Source Projects

This skill pack draws patterns from open-source academic writing projects:

| Project | License | What We Borrow |
|---------|---------|---------------|
| [Research-Equality/RE-paper-writing](https://github.com/Research-Equality/RE-paper-writing) | MIT | SKILL.md format, compilation/diff/verification patterns |
| [Ar9av/PaperOrchestra](https://github.com/Ar9av/PaperOrchestra) | MIT | 4-phase experiment aggregation, autorater scoring, halt rules |
| [Imbad0202/academic-research-skills](https://github.com/Imbad0202/academic-research-skills) | CC BY-NC 4.0 | Multi-reviewer audit, checkpoint pipeline (concepts only) |

This repository borrows workflow patterns and design ideas only. It does not copy upstream source code, scripts, or agent configurations. Academic content responsibility remains with the thesis author.

## LaTeX Template Credits

Based on the PKU College of Engineering PhD thesis template: https://www.coe.pku.edu.cn/service/biyedb/11187.html

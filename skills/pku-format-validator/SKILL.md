---
name: pku-format-validator
description: Validate PKU PhD thesis formatting against official requirements including margins, fonts, line spacing, paragraph indent, page headers/footers, and title hierarchy. Use before pre-submission review or after modifying setup/format files.
argument-hint: [tex-main-file-or-directory]
---

# PKU Format Validator Skill

Audit a PKU PhD thesis manuscript against the official formatting requirements documented in `AGENTS.md` Section 2.1. Catch layout, typography, and structural violations that would fail the college pre-review.

## When to Use

- After editing `setup/COEformat.tex`, `setup/package.tex`, or preamble files that control page geometry.
- Before the college pre-review submission to ensure format compliance.
- When switching between draft mode and final submission mode.
- After merging chapters from different sources where formatting may have diverged.

## Input

- **tex-main-file-or-directory**: Path to the main `.tex` file (default `COEmain.tex`) or the project root.
- The skill scans `setup/*.tex`, `setup/*.sty`, and the main file preamble for format definitions.

## Workflow

1. **Locate format configuration.** Find files that define:
   - `\geometry{...}` or `\usepackage[...]{geometry}`
   - `\ctexset{...}` font and title settings
   - `\setlength{\parindent}{...}`
   - `\linespread{...}` or `\setstretch{...}`
   - `\pagestyle{...}`, `\fancyhf`, `\renewcommand{\headrulewidth}`

2. **Check page geometry.** Verify against PKU requirements:
   | Parameter | Required | Tolerance |
   | --- | --- | --- |
   | Paper | A4 (210mm × 297mm) | exact |
   | Top margin | 25mm | ±1mm |
   | Bottom margin | 25mm | ±1mm |
   | Left margin | 30mm | ±1mm |
   | Right margin | 20mm | ±1mm |
   | Header height | 1.5cm | ±2mm |
   | Footer height | 1.75cm | ±2mm |

3. **Check fonts and sizes.** Verify:
   - Body text: 小四号 (12pt), Chinese 宋体, Western Times New Roman
   - Chapter title (一级): 三号 (16pt), 黑体
   - Section title (二级): 小三号 (15pt), 黑体
   - Subsection (三级): 四号 (14pt), 黑体
   - Figure/table captions: 五号 (10.5pt), 宋体
   - No unauthorized font substitutions

4. **Check line spacing and paragraphs.** Verify:
   - `\linespread{1.5}` or equivalent 1.5× line spacing
   - Paragraph indent: `2em` (2 Chinese characters)
   - No extra `\parskip` or `\parsep` that adds unwanted vertical space

5. **Check title hierarchy consistency.** Scan all `.tex` files for:
   - `\chapter{}` commands present and numbered correctly
   - No skipped levels (e.g., `\subsection` directly under `\chapter` without `\section`)
   - Consistent use of `\chapter*` for unnumbered front/back matter

6. **Generate audit report.** Write `format_audit_report.md`.

## Output

### `format_audit_report.md`

```markdown
# PKU Thesis Format Audit Report

## Page Geometry
| Parameter | Required | Actual | Status |
| --- | --- | --- | --- |
| Paper | A4 | A4 | PASS |
| Top margin | 25mm | 25mm | PASS |
| Left margin | 30mm | 28mm | WARNING |

## Fonts and Sizes
| Element | Required | Actual | Status |
| --- | --- | --- | --- |
| Body text | 小四号 宋体/Times New Roman | 12pt 宋体 | PASS |
| Chapter title | 三号 黑体 | 16pt 黑体 | PASS |

## Line Spacing & Paragraphs
| Parameter | Required | Actual | Status |
| --- | --- | --- | --- |
| Line spacing | 1.5× | 1.5× | PASS |
| Paragraph indent | 2em | 2em | PASS |

## Title Hierarchy
| Check | Status | Details |
| --- | --- | --- |
| No skipped levels | PASS | All sections properly nested |
| Chapter numbering | PASS | Continuous 1–4 |

## Overall Assessment: PASS / WARNING / FAIL
```

## Rules

- This skill is read-only; it does not modify `.tex` or `.sty` files.
- A single FAIL in any category makes the overall assessment FAIL.
- WARNING items are acceptable for drafts but must be resolved before final submission.
- Tolerances are given to accommodate minor rounding in `geometry` package calculations.
- If the project uses a custom `.cls` file instead of inline preamble settings, inspect the class file as well.

## Related Skills

- **latex-compilation-fix**: Run if format changes break the build.
- **submission-qa-gate**: Includes format validation in its pre-submission checklist.
- **latex-structure-refactor**: Use if title hierarchy needs reorganization.

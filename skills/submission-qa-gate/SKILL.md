---
name: submission-qa-gate
description: Run a comprehensive pre-submission quality assurance checklist covering compilation, formatting, references, figures, tables, supplementary materials, and venue requirements. Use as the final gate before submitting a manuscript.
argument-hint: [tex-file-or-directory]
---

# Submission QA Gate Skill

Use this skill as the final quality gate before submitting a manuscript. It runs a comprehensive checklist covering compilation, formatting, references, figures, tables, supplementary materials, metadata, and language. Any issue that would cause an immediate desk reject or reviewer complaint must be caught here.

## Inputs

- Manuscript `.tex` files or the root directory containing them.
- Optional: target venue template or formatting requirements document.
- Optional: bibliography `.bib` file if separate from the manuscript.
- Optional: supplementary materials files.
- Optional: previous `submission_qa_report.md` for regression checking.

## Checklist Categories

### 1. Compilation

Verify that the manuscript builds without errors.

| Item | Check | Severity if Failed |
| --- | --- | --- |
| C-01 | LaTeX compiles without errors (`pdflatex` / `xelatex` / `lualatex`) | CRITICAL |
| C-02 | No undefined references (`\ref`, `\cite`, `\eqref`) | CRITICAL |
| C-03 | No multiply-defined labels | HIGH |
| C-04 | No overfull or underfull hbox warnings that overflow margins | MEDIUM |
| C-05 | BibTeX / BibLaTeX runs cleanly with no warnings | HIGH |
| C-06 | All included files (images, `.sty`, `.cls`) are present | CRITICAL |
| C-07 | Output PDF is readable and not truncated | CRITICAL |

### 2. Formatting

Verify compliance with venue or institutional formatting requirements.

| Item | Check | Severity if Failed |
| --- | --- | --- |
| F-01 | Page count within the limit (excluding references if allowed) | CRITICAL |
| F-02 | Margins meet the required dimensions | HIGH |
| F-03 | Font sizes comply with minimum requirements | HIGH |
| F-04 | Line spacing matches requirements (single, 1.5, double) | HIGH |
| F-05 | Column layout is correct (single or double as required) | HIGH |
| F-06 | Headers and footers are correct (page numbers, running title) | MEDIUM |
| F-07 | Section numbering is correct and consistent | MEDIUM |
| F-08 | Equation numbering is sequential with no gaps | MEDIUM |
| F-09 | Appendix formatting follows venue guidelines | HIGH |
| F-10 | Cover page or title page meets requirements | HIGH |

### 3. References

Verify citation and bibliography integrity.

| Item | Check | Severity if Failed |
| --- | --- | --- |
| R-01 | Every `\cite` key exists in the bibliography | CRITICAL |
| R-02 | Every bibliography entry is cited at least once | HIGH |
| R-03 | Bibliography format is consistent (GB/T 7714 for Chinese thesis, or venue style) | HIGH |
| R-04 | No ghost citations (entries that cannot be traced to real publications) | CRITICAL |
| R-05 | DOIs are present and valid where applicable | MEDIUM |
| R-06 | Year, volume, pages, and authors are complete for each entry | HIGH |
| R-07 | Self-citations are within reasonable proportion (unless field norm) | LOW |
| R-08 | No duplicate entries with slightly different keys | HIGH |

### 4. Figures

Verify figure quality and correctness.

| Item | Check | Severity if Failed |
| --- | --- | --- |
| FG-01 | All figures are referenced in the text (`\ref{fig:...}`) | CRITICAL |
| FG-02 | Figure resolution is at least 300 DPI for print (or venue requirement) | HIGH |
| FG-03 | Captions are descriptive and self-contained | HIGH |
| FG-04 | Panel labels (a, b, c) are present and referenced correctly | HIGH |
| FG-05 | Axis labels and units are present on all plots | HIGH |
| FG-06 | Legends are readable and do not obscure data | MEDIUM |
| FG-07 | Color choices are distinguishable in grayscale (colorblind-safe) | MEDIUM |
| FG-08 | Figure numbering is sequential with no gaps | HIGH |
| FG-09 | File sizes are reasonable (no embedded raw data as images) | LOW |
| FG-10 | Figure placement does not cause large whitespace gaps | MEDIUM |

### 5. Tables

Verify table quality and correctness.

| Item | Check | Severity if Failed |
| --- | --- | --- |
| T-01 | All tables are referenced in the text (`\ref{tab:...}`) | CRITICAL |
| T-02 | Column headers are present and descriptive | HIGH |
| T-03 | Uncertainty notation is consistent (parentheses, plus-minus, significant digits) | HIGH |
| T-04 | Units are specified for all quantitative columns | HIGH |
| T-05 | Table caption is descriptive and self-contained | HIGH |
| T-06 | Table numbering is sequential with no gaps | HIGH |
| T-07 | Table does not overflow page margins | HIGH |
| T-08 | Values are consistent with the text and figures (cross-check) | CRITICAL |
| T-09 | Best results are clearly indicated (bold, underline) if required by venue | MEDIUM |
| T-10 | Footnotes and abbreviations in tables are explained | MEDIUM |

### 6. Supplementary Materials

Verify supplementary materials completeness.

| Item | Check | Severity if Failed |
| --- | --- | --- |
| S-01 | All supplementary items referenced in the main text exist | CRITICAL |
| S-02 | Supplementary figures and tables have separate numbering (S1, S2...) | HIGH |
| S-03 | Supplementary content is consistent with main text values | CRITICAL |
| S-04 | Supplementary file compiles or renders correctly | HIGH |
| S-05 | Cross-references between main text and supplementary are correct | HIGH |
| S-06 | Code availability statement references the correct repository or archive | HIGH |
| S-07 | Data availability statement is present and accurate | HIGH |

### 7. Metadata

Verify manuscript metadata completeness.

| Item | Check | Severity if Failed |
| --- | --- | --- |
| M-01 | Title is present, accurate, and within length limits | CRITICAL |
| M-02 | All authors are listed with correct order | CRITICAL |
| M-03 | Affiliations are complete and correctly mapped to authors | HIGH |
| M-04 | Corresponding author email is present and correct | CRITICAL |
| M-05 | Dates (received, revised, accepted) are correct if required | MEDIUM |
| M-06 | Acknowledgements section is present | HIGH |
| M-07 | Funding information is complete and accurate | HIGH |
| M-08 | Conflict of interest statement is present if required | CRITICAL |
| M-09 | Ethics approval statement is present if applicable | CRITICAL |
| M-10 | Keywords are present and within the required count | HIGH |
| M-11 | Abstract word count is within the limit | CRITICAL |

### 8. Language

Verify language quality and consistency.

| Item | Check | Severity if Failed |
| --- | --- | --- |
| L-01 | Grammar and spelling are correct throughout | HIGH |
| L-02 | Chinese thesis sections use zh-CN consistently where required | HIGH |
| L-03 | English sections use consistent spelling (US or UK, not mixed) | HIGH |
| L-04 | Abbreviations are defined at first use | HIGH |
| L-05 | Acronyms are used consistently after definition | MEDIUM |
| L-06 | No first-person / third-person mixing within a section | MEDIUM |
| L-07 | Tense usage is consistent (past for methods, present for facts) | MEDIUM |
| L-08 | No colloquial or informal language | LOW |
| L-09 | Mathematical notation is consistent with the nomenclature list | HIGH |
| L-10 | Section titles are parallel in structure | LOW |

## Item Status

Each checklist item receives one of three statuses:

| Status | Meaning |
| --- | --- |
| PASS | The check succeeds. No action needed. |
| FAIL | The check fails. Must be fixed before submission. |
| WARNING | The check reveals a potential issue that should be reviewed. May not require action. |

## Overall Assessment

After all items are checked, produce an overall assessment:

| Assessment | Criteria |
| --- | --- |
| SUBMIT_READY | No FAIL items. Zero or few WARNING items. Manuscript can be submitted as-is. |
| FIX_REQUIRED | One or more FAIL items exist. Must resolve all FAIL items before submission. |
| REVIEW_RECOMMENDED | No FAIL items but multiple WARNING items. Recommend human review before submission. |

The overall assessment is the most conservative interpretation. A single CRITICAL FAIL is sufficient for FIX_REQUIRED regardless of how many items pass.

## Output

Write `submission_qa_report.md` containing:

```markdown
# Submission QA Report

## Manuscript: [title]
## Date: [YYYY-MM-DD]
## Target Venue: [venue name or "Chinese thesis (PKU template)"]

## Overall Assessment: [SUBMIT_READY / FIX_REQUIRED / REVIEW_RECOMMENDED]

## Summary

| Category | Total | PASS | FAIL | WARNING |
| --- | --- | --- | --- | --- |
| Compilation | 7 | ... | ... | ... |
| Formatting | 10 | ... | ... | ... |
| References | 8 | ... | ... | ... |
| Figures | 10 | ... | ... | ... |
| Tables | 10 | ... | ... | ... |
| Supplementary | 7 | ... | ... | ... |
| Metadata | 11 | ... | ... | ... |
| Language | 10 | ... | ... | ... |
| **Total** | **73** | **...** | **...** | **...** |

## Detailed Results

### 1. Compilation

| Item | Status | Details |
| --- | --- | --- |
| C-01 | PASS / FAIL / WARNING | [details] |
| C-02 | PASS / FAIL / WARNING | [details] |
| ... | ... | ... |

### 2. Formatting

| Item | Status | Details |
| --- | --- | --- |
| F-01 | PASS / FAIL / WARNING | [details including current vs required values] |
| ... | ... | ... |

### 3. References

| Item | Status | Details |
| --- | --- | --- |
| R-01 | PASS / FAIL / WARNING | [details including specific citation keys if problematic] |
| ... | ... | ... |

### 4. Figures

| Item | Status | Details |
| --- | --- | --- |
| FG-01 | PASS / FAIL / WARNING | [details including specific figure numbers if problematic] |
| ... | ... | ... |

### 5. Tables

| Item | Status | Details |
| --- | --- | --- |
| T-01 | PASS / FAIL / WARNING | [details including specific table numbers if problematic] |
| ... | ... | ... |

### 6. Supplementary Materials

| Item | Status | Details |
| --- | --- | --- |
| S-01 | PASS / FAIL / WARNING | [details] |
| ... | ... | ... |

### 7. Metadata

| Item | Status | Details |
| --- | --- | --- |
| M-01 | PASS / FAIL / WARNING | [details] |
| ... | ... | ... |

### 8. Language

| Item | Status | Details |
| --- | --- | --- |
| L-01 | PASS / FAIL / WARNING | [details] |
| ... | ... | ... |

## Action Items

### Must Fix (FAIL items)

1. [CRITICAL] C-01: [description and how to fix]
2. [HIGH] R-02: [description and how to fix]
...

### Recommended Review (WARNING items)

1. [MEDIUM] FG-07: [description and suggestion]
...

### Passed (no action needed)

[Count of PASS items by category]
```

## Usage

1. Run this skill as the absolute final step before submission.
2. Review the Overall Assessment immediately. If FIX_REQUIRED, do not submit.
3. Address all FAIL items in order of severity (CRITICAL first).
4. Re-run after fixes to verify all items now PASS.
5. Archive the report for submission records.

## Integration with Other Skills

This skill assumes the following have already been run and their issues resolved:

1. `paper-compilation-skill` -- the manuscript must compile before QA begins.
2. `claim-evidence-map-skill` -- claim-evidence alignment verified.
3. `results-consistency-skill` -- numerical consistency verified.
4. `manuscript-autorater-skill` -- quality scoring completed.
5. `multi-reviewer-audit-skill` -- peer review simulation completed.

Running this QA gate without resolving issues from the above skills will produce numerous FAIL items that could have been caught earlier.

## Dependencies

- `paper-compilation-skill`: needed to verify compilation items.
- LaTeX installation with the appropriate engine (`xelatex` for Chinese thesis template).
- BibTeX or BibLaTeX for reference verification.

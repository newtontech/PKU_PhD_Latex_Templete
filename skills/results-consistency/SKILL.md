---
name: results-consistency
description: Audit consistency among manuscript text, numerical results, figures, tables, captions, supplementary information, code outputs, logs, and processed result files. Use before revising results, abstracts, captions, conclusions, or reviewer responses.
argument-hint: [tex-file-or-directory]
---

# Results Consistency Skill

Use this skill to prevent mismatches such as a table reporting 0.83 while the text says 0.87. It reads evidence and reports conflicts before any prose polishing.

## Inputs

- Manuscript source or extracted text.
- Project file inventory.
- Claim-evidence matrix.
- Figures, tables, captions, SI, result CSV/JSON files, logs, notebooks, and scripts.

## Audit Targets

Check consistency for:

- Numerical values, percentages, confidence intervals, p-values, rankings, and units.
- Directionality such as increase/decrease, higher/lower, faster/slower.
- Dataset, material, molecule, instrument, and model names.
- Figure/table numbering and panel labels.
- Caption takeaways versus plotted or tabulated data.
- Abstract and conclusion summaries versus body results.
- SI values versus main text values.

## Report Schema

Output `results_consistency_audit.md` with:

| Field | Meaning |
| --- | --- |
| `finding_id` | Stable ID such as `R001` |
| `location` | Manuscript, caption, table, figure, SI, or response location |
| `manuscript_value` | Value or phrase in the manuscript |
| `source_value` | Value or phrase from evidence |
| `source_evidence` | File ID, table, figure, log, code output, or DOI |
| `consistency_status` | MATCH, ROUNDING_OK, MISMATCH, MISSING_SOURCE, AMBIGUOUS |
| `severity` | low, medium, high, blocker |
| `recommended_action` | keep, correct, weaken, add_source, ask_author |
| `notes` | Short rationale |

## Severity Rules

- `blocker`: value changes conclusion, ranking, significance, or reviewer-facing claim.
- `high`: visible mismatch between text, table, figure, or SI.
- `medium`: rounding, unit, label, or naming issue that can confuse readers.
- `low`: formatting or style issue with no scientific effect.

## Editing Rules

- Do not silently rewrite numbers without a source value.
- If multiple source values exist, record all candidates and ask for a decision.
- Treat missing scripts or missing raw data as evidence gaps.
- Use exact source units and document conversions.
- Preserve significant figures unless the target venue or evidence supports a change.

## Completion Check

The audit is complete when all headline results, abstract numbers, conclusion numbers, figure captions, table values, and SI cross-references have a status. Blockers must be resolved or listed in the human decision checklist.

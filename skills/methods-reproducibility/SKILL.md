---
name: methods-reproducibility
description: Audit and enrich scientific manuscript methods using only real experiment records, scripts, logs, notebooks, metadata, instruments, software versions, data splits, seeds, and author notes. Use when method details must be made reproducible without fabricating parameters.
argument-hint: [tex-file-or-directory]
---

# Methods Reproducibility Skill

Use this skill to make the methods section reproducible while staying evidence-bound.

## Inputs

- Manuscript methods text.
- Project file inventory.
- Claim-evidence matrix.
- Scripts, notebooks, environment files, logs, metadata, raw data descriptions, processed data descriptions, and author notes.

## What To Extract

Check for:

- Dataset names, sources, inclusion/exclusion rules, preprocessing, and splits.
- Random seeds, repetitions, folds, train/validation/test separation, and leakage controls.
- Model names, versions, hyperparameters, baselines, metrics, and selection criteria.
- Software versions, package managers, hardware, operating system, and runtime environment.
- Instruments, reagents, sample preparation, measurement settings, calibration, and uncertainty.
- Statistical tests, confidence intervals, error bars, correction methods, and sample sizes.
- Figure/table generation scripts and transformation steps.

## Evidence Classes

For each method detail, label source quality:

- `MANUSCRIPT_SUPPORTED`: already stated in the manuscript.
- `EVIDENCE_SUPPORTED`: present in scripts, logs, notebooks, metadata, or author notes.
- `REFERENCE_SUPPORTED`: supported by a cited protocol or standard.
- `MISSING`: needed for reproducibility but absent.
- `INCONSISTENT`: manuscript and evidence disagree.

## Output Schema

Create `reproducibility_checklist.md` with:

| Field | Meaning |
| --- | --- |
| `item_id` | Stable ID such as `M001` |
| `method_topic` | data, model, experiment, instrument, statistics, environment, figure_generation, other |
| `current_text` | Manuscript wording or missing |
| `source_evidence` | File IDs, line ranges, log names, DOI, or author note IDs |
| `status` | MANUSCRIPT_SUPPORTED, EVIDENCE_SUPPORTED, REFERENCE_SUPPORTED, MISSING, INCONSISTENT |
| `recommended_edit` | Exact proposed wording or TODO |
| `risk` | low, medium, high |

## Writing Rules

- Add exact parameters only when evidence shows them.
- If a parameter is missing, write a TODO or reviewer-facing limitation, not a guessed value.
- Do not run experiments to fill gaps unless explicitly asked.
- Keep method wording neutral and reproducible.
- Separate what was done from why it was chosen.

## Completion Check

The methods audit is complete when every method claim needed to reproduce the main results is either supported by evidence, listed as missing, or marked inconsistent for author decision.

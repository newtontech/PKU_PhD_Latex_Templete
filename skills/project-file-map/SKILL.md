---
name: project-file-map
description: Build a read-only inventory of manuscript files, figures, tables, notebooks, scripts, logs, raw and processed data, supplementary information, references, and author notes before scientific manuscript revision. Use when evidence sources must be discovered before editing a paper.
argument-hint: [project-root]
---

# Project File Map Skill

Use this skill before revising a manuscript. Its job is to find the real evidence surface and describe what each file can support. It must not edit manuscript content.

## Inputs

- Project root.
- Optional manuscript path.
- Optional evidence roots such as `experiments/`, `notebooks/`, `scripts/`, `logs/`, `figures/`, `tables/`, `data/`, `references/`, or `SI/`.

## Read-Only Discovery

Prefer fast local commands:

```bash
pwd
git status --short --branch
rg --files
find . -maxdepth 3 -type f
```

For LaTeX projects, identify:

- Main entrypoint such as `main.tex`, `COEmain.tex`, or `manuscript.tex`.
- Included section files from `\input{...}` and `\include{...}`.
- Bibliography files from `\bibliography{...}` or `\addbibresource{...}`.
- Figure files referenced by `\includegraphics`.

For DOCX projects, identify:

- Manuscript `.docx`.
- Exported text if available.
- Media and supplementary files.
- Reviewer comment files.

## Inventory Schema

Output `project_file_inventory.md` or equivalent structured table with:

| Field | Meaning |
| --- | --- |
| `file_id` | Stable ID such as `M001`, `F003`, `D012`, `R002` |
| `path` | Repository-relative or project-relative path |
| `type` | manuscript, figure, table, code, notebook, log, raw_data, processed_data, reference, SI, author_note, other |
| `role` | What this file can support |
| `provenance` | Source, generation script, DOI, URL, or author note if known |
| `sensitivity` | public, private, confidential, unknown |
| `last_modified` | Filesystem or git timestamp when useful |
| `confidence` | high, medium, low |
| `notes` | Gaps, warnings, or parsing issues |

## Evidence Readiness

Mark each file:

- `READY`: readable and likely useful as evidence.
- `NEEDS_PARSING`: requires conversion, OCR, notebook execution, or manual export.
- `MISSING_DEPENDENCY`: referenced but not found.
- `PRIVATE_REVIEW_ONLY`: can guide revision but must not be copied into public docs.
- `UNKNOWN`: role unclear.

## Output Rules

- Do not infer evidence that is not present.
- Do not run notebooks or scripts unless the user explicitly asks for execution.
- Do not copy private data into examples.
- Record broken paths and missing references as evidence gaps.
- Pass the inventory to downstream claim, results, methods, and diff skills.

## Completion Check

The task is complete when the inventory identifies the manuscript entrypoint, evidence candidates, reference files, generated figures/tables, and known missing or sensitive files.

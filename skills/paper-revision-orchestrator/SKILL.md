---
name: paper-revision-orchestrator
description: Orchestrate evidence-bound scientific manuscript revision across file mapping, claim-evidence mapping, structure, methods reproducibility, results consistency, and reviewable diff generation. Use when revising a scientific manuscript from LaTeX or DOCX together with experiment folders, figures, tables, logs, references, or reviewer comments.
argument-hint: [tex-file-or-directory]
---

# Paper Revision Orchestrator

Use this skill as the top-level coordinator for evidence-bound manuscript revision. It does not rewrite the paper by itself. It routes work to focused sub-skills, enforces evidence gates, and produces a final decision report.

## Inputs

- Manuscript source: LaTeX, DOCX, Markdown, or exported text.
- Evidence repository: experiments, notebooks, scripts, logs, raw results, processed results, figures, tables, SI, references, and author notes.
- Optional target: thesis rules, journal guidelines, reviewer comments, word/page limits, or submission format.

## Non-Negotiable Rules

- Do not invent experiments, datasets, baselines, numerical results, ablations, mechanisms, citations, or limitations.
- Only add scientific content when it is supported by manuscript text, evidence files, verified references, or explicit author notes.
- Preserve LaTeX labels, citations, equations, cross-references, and figure/table references unless a change is explicitly justified.
- For uncertain edits, leave TODO comments or decision items instead of silently rewriting.
- Keep public examples free of private manuscripts, reviewer reports, unpublished data, and personal information.

## Evidence Status

Use exactly these support levels:

- `VERIFIED`: direct support from evidence or verified literature.
- `WEAKLY_SUPPORTED`: indirect or incomplete support; lower the claim strength.
- `MISSING`: no support found; do not add or preserve as a scientific assertion.
- `CONTRADICTED`: evidence conflicts with manuscript; block until resolved.
- `NEEDS_HUMAN_DECISION`: requires author judgment, policy choice, or confidential context.

## Workflow

1. Run `project-file-map-skill`.
   - Produce an inventory of manuscript, evidence, references, figures, tables, and sensitive files.
   - Stop if the manuscript or evidence root cannot be identified.
2. Run `claim-evidence-map-skill`.
   - Extract core claims and bind them to evidence IDs.
   - Stop on unresolved `CONTRADICTED` claims.
3. Run `results-consistency-skill`.
   - Compare numbers, entities, units, captions, tables, SI, and code/log outputs.
   - Treat unresolved numeric conflicts as blockers.
4. Run `section-architecture-skill`.
   - Propose structural moves only after evidence status is known.
   - Keep facts unchanged unless supported by the claim matrix.
5. Run `methods-reproducibility-skill`.
   - Fill method details only from evidence or author notes.
   - Missing parameters become TODO items.
6. Run `latex-docx-diff-skill`.
   - Generate reviewable edits through patch, `latexdiff`, tracked changes, or comments.
7. Produce the final revision packet.

## Parallelization

After the project file map exists, the claim audit, results audit, and methods audit can run in parallel because they read from the same inventory and write separate reports. Structure revision waits for those reports. Diff generation waits for all accepted edits.

## Required Final Packet

- Revised manuscript or patch.
- Diff artifact.
- Claim-evidence matrix.
- Unsupported claims list.
- Contradictions list.
- Results consistency audit.
- Methods reproducibility checklist.
- Added content with evidence IDs.
- Removed or weakened content with reasons.
- AI-use disclosure draft when requested by target venue.
- Human decision checklist.

## Final Gate

Before reporting completion:

- Every changed factual or scientific claim has a source evidence ID.
- Author decision IDs may record scope, strategy, confidential context, or unresolved judgment, but they do not substitute for evidence.
- Every `MISSING` or `CONTRADICTED` item is removed, weakened, or listed as unresolved.
- Every numeric edit traces to a source value.
- The diff is reviewable by a human author.
- No private evidence has been copied into public examples or documentation.

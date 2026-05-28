---
name: latex-docx-diff
description: Produce reviewable manuscript revision artifacts for LaTeX and DOCX, including patches, latexdiff output, tracked-change boundaries, comments, and human decision checklists. Use after evidence-bound edits have been planned and accepted.
argument-hint: [original-tex revised-tex]
---

# LaTeX DOCX Diff Skill

Use this skill to make manuscript edits auditable. It does not decide scientific content; it packages accepted evidence-bound edits so the author can review every change.

## Inputs

- Original manuscript source.
- Accepted revision plan.
- Claim-evidence matrix.
- Results consistency audit.
- Methods reproducibility checklist.
- Optional reviewer comments and response draft.

## LaTeX Workflow

1. Work on a copy or branch.
2. Preserve labels, citation keys, equation labels, figure/table labels, and bibliography commands.
3. Apply only accepted edits.
4. Run a syntax check or minimal compile when available.
5. Generate a patch:

```bash
git diff -- manuscript.tex body/*.tex > revision_outputs/manuscript.patch
```

6. If `latexdiff` is available and an original snapshot exists, generate a marked PDF source:

```bash
latexdiff original.tex revised.tex > revision_outputs/manuscript_latexdiff.tex
```

7. If `latexdiff` is unavailable, state that patch review is the fallback.

## DOCX Workflow

- Prefer tracked changes in a real DOCX editor when available.
- If direct tracked changes are unavailable, create a comment-style revision report with:
  - original text
  - proposed text
  - evidence IDs
  - support level
  - author decision status
- Do not flatten reviewer comments into unreviewable prose.
- Do not strip metadata unless the user asks for anonymization.

## Metadata And Privacy Check

Before sharing DOCX artifacts outside the local author workflow:

- Check whether tracked changes, comments, author names, reviewer names, timestamps, paths, and custom document properties contain private or identifying metadata.
- For double-blind review or confidential reviewer workflows, require anonymization or explicit author approval before external distribution.
- If metadata is preserved for reviewability, state that the artifact is for internal review only.

## Diff Package

Output a `revision_outputs/` packet:

| File | Purpose |
| --- | --- |
| `manuscript_revised.*` | Editable revised manuscript |
| `manuscript.patch` | Reviewable source diff |
| `manuscript_latexdiff.tex` | Optional LaTeX marked diff |
| `changed_claims.md` | Scientific claims changed and evidence IDs |
| `deleted_claims.md` | Removed claims and reasons |
| `human_decision_checklist.md` | Items requiring author decision |

## Safety Rules

- Never overwrite the only copy of a manuscript.
- Never collapse unsupported TODOs into polished text.
- Keep generated diff artifacts separate from source unless the user requests otherwise.
- Do not include private evidence files in public diff examples.
- Keep reviewer responses synchronized with manuscript locations.

## Completion Check

The task is complete when a human author can inspect each change, trace scientific edits back to evidence IDs, and see unresolved decisions separately from accepted revisions.

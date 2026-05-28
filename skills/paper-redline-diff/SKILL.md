---
name: paper-redline-diff
description: Generate change-tracked LaTeX diffs between original and revised manuscripts using latexdiff and git diff. Produce redline PDFs for advisor review and revision verification. Use when you need a visible record of all changes.
argument-hint: [old-tex new-tex or --git-rev REV]
---

# Paper Redline Diff Skill

Use this skill to produce a redline (change-tracked) PDF showing every addition, deletion, and modification between two versions of a LaTeX manuscript. This is essential for advisor review, co-author communication, and revision verification.

## When to Use

- After revising a manuscript and needing to show the advisor exactly what changed.
- When responding to reviewer comments and needing a marked-up version of the revised text.
- Before committing changes, to review the full scope of edits.
- When comparing two branches or git revisions of the same paper.
- As part of a journal resubmission package that requires a marked-up manuscript.

## Input

Two modes of operation:

1. **File pair mode:** Provide paths to the old and new `.tex` files.
   ```
   /path/to/old_version.tex /path/to/new_version.tex
   ```

2. **Git revision mode:** Provide `--git-rev REV` to compare the working tree against a specific git revision.
   ```
   --git-rev HEAD~3
   --git-rev v1.2
   --git-rev main
   ```

If neither is provided, the skill defaults to comparing the working tree against the last committed version (`HEAD`).

## Workflow

1. **Resolve file inputs.** Based on the argument mode:
   - File pair: use the two provided `.tex` files directly.
   - Git revision: extract the old version using `git show REV:path/to/file.tex` and use the current working tree version as the new file.
   - Default: compare `HEAD` to working tree.

2. **Flatten multi-file projects.** If the main `.tex` file uses `\input{}` or `\include{}` to pull in other files, flatten them into a single temporary file so that the diff captures changes across all section files:
   ```bash
   # Flatten by recursively replacing \input{file} with file contents
   # Preserve \input commands for bibliography and style files
   ```
   Skip flattening if both old and new versions are already single files.

3. **Generate LaTeX diff.** Run `latexdiff` with the chosen markup style:
   ```bash
   latexdiff --markup=UNDERLINE old.tex new.tex > redline.tex
   ```
   Available markup styles:
   - `UNDERLINE`: Added text underlined, deleted text struck through (recommended for thesis review).
   - `CHANGEBAR`: Changes marked with change bars in the margin.
   - `CULINECHBAR`: Combination of colored underline and change bars.
   - `CROSSOUT`: Deleted text crossed out in red, added text in blue.
   - `INVISIBLE`: No visual markup (for programmatic comparison only).

   Default: `UNDERLINE` for readability. Override via the `--markup` argument.

4. **Handle latexdiff failures.** Common issues:
   - Custom commands cause parsing errors: wrap them with `--exclude-textcmd` or `--replace-textcmd`.
   - Encoding mismatches: ensure both files use UTF-8.
   - If `latexdiff` is not installed, fall back to `git diff --no-color` for a text patch and note the limitation.

5. **Generate git diff patch (optional).** If the git revision mode is active, also produce a unified diff:
   ```bash
   git diff REV -- '*.tex' '*.bib' > changes.patch
   ```
   This provides a machine-readable complement to the visual redline.

6. **Compile redline to PDF.** Compile the redline `.tex` file using the same pipeline as paper-compilation:
   ```bash
   xelatex -interaction=nonstopmode redline.tex
   bibtex redline
   xelatex -interaction=nonstopmode redline.tex
   xelatex -interaction=nonstopmode redline.tex
   ```

7. **Generate change summary.** Count additions, deletions, and modified blocks from the latexdiff output or git diff stats. Include in the report.

## Output

- **redline.pdf**: The change-tracked PDF ready for advisor or reviewer review.
- **redline.tex**: The intermediate LaTeX file with diff markup (kept for debugging).
- **changes.patch**: Unified diff patch (in git revision mode).
- **diff_report.txt**: Summary of changes.

  ```
  === Redline Diff Report ===
  Old version: HEAD~3 (commit abc1234)
  New version: working tree
  Markup style: UNDERLINE

  Changes:
  - Sections modified: 4 (Introduction, Methods, Results, Discussion)
  - Lines added: 87
  - Lines deleted: 42
  - Lines changed: 31
  - Figures changed: 2
  - Tables changed: 1
  - Citation changes: +5 added, -2 removed

  PDF output: redline.pdf
  ```

## Rules

- Always flatten multi-file projects before diffing to capture cross-file changes.
- Preserve the original documentclass and preamble from the new version so the redline compiles correctly.
- Do not modify either the old or new source files; work only with copies or temporary files.
- If the redline compilation fails, provide the `redline.tex` file and the compilation error log so the user can fix issues manually.
- Clean up temporary files (flattened `.tex`) after completion unless `--keep-temp` is specified.
- For very large diffs (500+ changed lines), warn the user that the redline PDF may be difficult to read and suggest reviewing section by section.

## Related Skills

- **paper-compilation**: Used to compile the redline `.tex` to PDF.
- **paper-revision-orchestrator**: Orchestrates the full revision cycle including redline generation.
- **latex-docx-diff**: For comparing LaTeX against Word documents.
- **citation-verification-gate**: Run before redlining to ensure both versions have valid references.

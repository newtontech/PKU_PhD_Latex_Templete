---
name: paper-compilation
description: Compile LaTeX papers to PDF with XeLaTeX, automatic error detection, BibTeX reference resolution, and post-compile reporting. Adapted for PKU thesis template (ctexbook, COEmain.tex). Use when compiling, debugging LaTeX errors, or checking build status.
argument-hint: [tex-file-or-directory]
---

# Paper Compilation Skill

Use this skill to compile LaTeX manuscripts into PDF, resolve build errors, and produce a compilation report. It is tuned for the PKU thesis template but works for any XeLaTeX project.

## When to Use

- After editing any `.tex`, `.bib`, or `.cls` file and needing an updated PDF.
- When debugging LaTeX build failures such as undefined control sequences, missing packages, or font errors.
- Before submission to verify the document compiles cleanly with no warnings.
- As a verification step after running other skills (citation-verification-gate, paper-redline-diff).

## Input

- **tex-file-or-directory**: Path to the main `.tex` file or the project root directory.
  - Default main file: `COEmain.tex` in the project root.
  - If a directory is given, the skill locates the main `.tex` file by checking for `\documentclass{ctexbook}` or `\begin{document}`.
- Optional: specific `.tex` file path to override auto-detection.

## Workflow

1. **Locate main file.** If a directory is provided, find the entry `.tex` file. For PKU templates this is `COEmain.tex`. Confirm it contains `\documentclass{ctexbook}` or equivalent.

2. **First XeLaTeX pass.**
   ```bash
   xelatex -interaction=nonstopmode -file-line-error COEmain.tex
   ```
   Capture stdout and stderr. Parse for errors and warnings.

3. **BibTeX pass.** If the document uses `\bibliography{}` or `\addbibresource{}`, run:
   ```bash
   bibtex COEmain
   ```
   or for BibLaTeX:
   ```bash
   biber COEmain
   ```
   Detect which backend the project uses by checking for `\usepackage[backend=biber]{biblatex}` or `\bibliographystyle{}`.

4. **Second XeLaTeX pass.** Resolves citation numbers and cross-references:
   ```bash
   xelatex -interaction=nonstopmode -file-line-error COEmain.tex
   ```

5. **Third XeLaTeX pass.** Stabilizes page numbers and back-references:
   ```bash
   xelatex -interaction=nonstopmode -file-line-error COEmain.tex
   ```

6. **Error correction loop.** If any pass fails with errors, classify and attempt fixes:

   | Error Pattern | Typical Cause | Resolution |
   | --- | --- | --- |
   | `Undefined control sequence` | Misspelled command or missing package | Check package imports, fix typo |
   | `Missing $ inserted` | Math-mode content outside math delimiters | Wrap in `$...$` or `\(...\)` |
   | `Missing } inserted` | Unbalanced braces | Locate unmatched `{` in the reported line |
   | `Citation 'X' undefined` | Missing `.bib` entry or typo in key | Run citation-verification-gate skill |
   | `File 'X' not found` | Missing figure or input file | Verify path, check case sensitivity |
   | `Font shape 'X' not available` | Missing font or wrong font name | Check system fonts, use fallback |
   | `Package X not found` | Missing LaTeX package | Install via `tlmgr install X` |
   | `Too many unprocessed floats` | Figure/table placement overflow | Add `\clearpage` or use `[htbp]` placement |

   Rerun the failing pass after each fix. Limit correction attempts to 5 iterations to avoid infinite loops.

7. **Post-compile report.** After successful compilation, generate a summary:

   ```
   === Compilation Report ===
   PDF output: COEmain.pdf
   Pages: <page count from log>
   Warnings: <count> (list types: overfull hbox, underfull vbox, etc.)
   Citation warnings: <count of undefined citations>
   Label warnings: <count of undefined references>
   Build time: <elapsed seconds>
   ```

## Output

- **COEmain.pdf** (or corresponding PDF) in the working directory.
- **compilation_report.txt** with page count, warnings, citation stats, and build status.
- Terminal output summarizing PASS or FAIL with actionable error descriptions.

## Rules

- Always use XeLaTeX (not pdfLaTeX) for PKU templates because ctexbook requires Unicode and system font support.
- Run the full 3-pass pipeline (xelatex -> bibtex/biber -> xelatex -> xelatex) to ensure references and page numbers stabilize.
- Use `-interaction=nonstopmode` so the build does not hang on errors; collect errors from the log instead.
- Do not modify `.tex` files unless the user explicitly asks for error correction. Report errors and suggest fixes.
- If `latexmk` is available, it may be used as an alternative:
  ```bash
  latexmk -xelatex -interaction=nonstopmode COEmain.tex
  ```
- Preserve the `.aux`, `.bbl`, `.blg`, `.log`, and `.toc` intermediate files for debugging; do not delete them automatically.
- If the same error persists after 3 correction attempts, stop and report the issue to the user with the relevant log excerpt.

## Related Skills

- **citation-verification-gate**: Run before compilation to catch broken citation keys and missing figures.
- **paper-redline-diff**: Compile a redline diff PDF after generating the marked-up LaTeX.
- **project-file-map**: Discover the project structure and locate the main `.tex` file and bibliography.
- **paper-revision-orchestrator**: Orchestrates compilation as the final step of a revision workflow.

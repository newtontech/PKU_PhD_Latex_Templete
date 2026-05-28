---
name: latex-structure-refactor
description: Reorganize LaTeX file structure, fix label and cross-reference consistency, split oversized chapter files, and ensure clean \input/\include hierarchy. Use when the manuscript file organization needs cleanup before content revision.
argument-hint: [tex-main-file-or-directory]
---

# LaTeX Structure Refactor

Analyze and reorganize the LaTeX project file hierarchy, fix cross-reference and label consistency issues, and propose clean splits for oversized chapter files while preserving all references.

## When to Use

- Before starting a major content revision when the file organization is messy.
- When chapter files exceed 500 lines and become hard to navigate.
- After merging contributions from multiple authors who used inconsistent label conventions.
- When cross-reference warnings appear during compilation (`LaTeX Warning: Reference ... undefined`).
- Before running skills that need reliable file-to-section mapping (e.g., `claim-evidence-map`).

## Input

- **Required**: Path to the main `.tex` file (e.g., `main.tex`) or the project root directory containing it.
- The tool will recursively discover the full `\input`/`\include` tree starting from the main file.

## Workflow

1. **Build the inclusion tree**. Parse the main `.tex` file and recursively follow all `\input{}` and `\include{}` directives to map the complete file hierarchy. Record parent-child relationships and nesting depth.

2. **Audit label conventions**. Scan every `.tex` file for `\label{...}` commands. For each label, record:
   - The file and line where it appears.
   - The enclosing environment or section (chapter, section, figure, table, equation).
   - A suggested prefix based on the enclosing context (e.g., `ch:` for chapters, `sec:` for sections, `fig:` for figures, `tab:` for tables, `eq:` for equations).

3. **Detect label issues**. Flag the following problems:
   - **Duplicate labels**: Two or more `\label` commands with the same key.
   - **Similar labels**: Labels that differ only by casing, hyphens vs underscores, or minor typos (edit distance <= 2).
   - **Orphan labels**: Labels that are defined but never referenced by `\ref{}`, `\eqref{}`, `\autoref{}`, or `\pageref{}`.
   - **Dangling references**: `\ref{}` commands that point to labels that do not exist anywhere in the project.
   - **Inconsistent prefixes**: Labels in the same category (e.g., all figures) using mixed prefix styles.

4. **Analyze file sizes**. For each `.tex` file in the tree, count lines. Flag any file exceeding 500 lines as a candidate for splitting. Propose split points at `\section` or `\subsection` boundaries.

5. **Check file self-containment**. For each included file, verify:
   - All `\ref{}` and `\cite{}` targets exist within the project.
   - Custom commands used in the file are defined in the preamble or a shared `.sty`/`.tex` file.
   - No unclosed environments that span across file boundaries (e.g., a `\begin{figure}` in one file with `\end{figure}` in another).

6. **Generate refactor plan** (see Output section).

## Output

### `refactor_plan.md`

A structured plan with ordered actions:

```markdown
## LaTeX Refactor Plan

### File Tree (Current)

main.tex
+-- chapters/
    +-- chapter1.tex (320 lines)
    +-- chapter2.tex (780 lines) [OVERSIZED]
    +-- chapter3.tex (410 lines)
+-- appendices/
    +-- appendix_a.tex (95 lines)
+-- preamble/
    +-- packages.tex
    +-- macros.tex

---

### Action 1: Split oversized file
- **File**: `chapters/chapter2.tex` (780 lines)
- **Action**: SPLIT
- **Details**: Split into three files at \section boundaries:
  - `chapters/chapter2_intro.tex` (lines 1-180): sections 2.1-2.2
  - `chapters/chapter2_methods.tex` (lines 181-520): section 2.3
  - `chapters/chapter2_results.tex` (lines 521-780): sections 2.4-2.5
- **Update**: `main.tex` must replace `\input{chapters/chapter2}` with three sequential `\input` commands.

### Action 2: Fix duplicate labels
- **File**: `chapters/chapter3.tex`
- **Action**: RENAME_LABEL
- **Details**: Two labels share key `fig:xrd_pattern`. Rename the second occurrence to `fig:xrd_pattern_annealed`.
- **Also update**: `\ref{fig:xrd_pattern}` on line 203 of `chapters/chapter3.tex` to `\ref{fig:xrd_pattern_annealed}`.

### Action 3: Fix inconsistent prefixes
- **File**: `chapters/chapter1.tex`
- **Action**: RENAME_LABEL (batch)
- **Details**: Figure labels use mixed prefixes (`fig:`, `figure:`, `F:`). Standardize all to `fig:`.
- **Rename map**:
  - `figure:microstructure` -> `fig:microstructure`
  - `F:tem_image` -> `fig:tem_image`
- **Also update**: All corresponding `\ref{}` commands in `chapters/chapter1.tex`.

### Action 4: Resolve dangling references
- **File**: `chapters/chapter3.tex` line 95
- **Action**: FLAG
- **Details**: `\ref{tab:mechanical_properties}` references a label that does not exist. Either add the label to the table environment or remove the reference.

### Action 5: Reorder includes for logical flow
- **File**: `main.tex`
- **Action**: REORDER
- **Details**: Appendices are included before the bibliography. Move `\input{appendices/appendix_a}` after `\bibliography{refs}` or use `\backmatter` conventions.
```

### `label_registry.csv`

A machine-readable registry of all labels in the project:

```csv
label_key,file,line,enclosing_env,suggested_prefix,status
fig:xrd_pattern,chapters/chapter2.tex,45,figure,fig,OK
fig:xrd_pattern,chapters/chapter3.tex,12,figure,fig,DUPLICATE
sec:introduction,chapters/chapter1.tex,8,section,sec,OK
tab:mechanical_properties,,,table,tab,DANGLING_REF
```

## Rules

- **Preserve all keys.** Never delete or rename a `\label`, `\ref`, or `\cite` key without also updating every reference to it across the entire project.
- **Prefer minimal disruption.** If the file hierarchy works and only labels need fixing, do not propose file splits.
- **Splits must be at section boundaries.** Never split a file mid-paragraph or mid-environment.
- **Test after refactor.** The plan should include a verification step: compile the project after applying changes and check for undefined reference warnings.
- **Back up before applying.** Recommend creating a git commit or backup before applying the refactor plan.
- **No content changes.** This skill only reorganizes structure and fixes references. It does not rewrite prose or change document content.

## Related Skills

- **section-architecture**: Analyzes the logical flow and completeness of manuscript sections.
- **claim-evidence-map**: Benefits from clean file structure for accurate claim location.
- **paper-compilation**: Run after refactoring to verify the project still compiles cleanly.
- **paper-revision-orchestrator**: Can include structural refactoring as a revision phase.

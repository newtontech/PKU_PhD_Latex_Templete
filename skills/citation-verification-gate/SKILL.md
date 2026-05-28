---
name: citation-verification-gate
description: Cross-check LaTeX citation keys against BibTeX entries, verify figure paths exist, detect duplicate labels, and validate cross-references. Use before compilation or submission to catch broken references.
argument-hint: [tex-file-or-directory]
---

# Citation Verification Gate Skill

Use this skill to audit all cross-references in a LaTeX project before compilation or submission. It catches broken citation keys, missing figures, duplicate labels, and dangling references that would otherwise surface as warnings or errors during the build.

## When to Use

- Before running paper-compilation to ensure a clean build with zero citation warnings.
- Before submission to verify every `\cite{}`, `\ref{}`, and figure path resolves.
- After major restructuring (moving files, renaming labels, merging sections).
- When the compilation log shows `Citation 'X' undefined` or `Reference 'X' on page Y undefined`.

## Input

- **tex-file-or-directory**: Path to the main `.tex` file or the project root directory.
  - If a directory is given, the skill recursively finds all `.tex` files.
- Bibliography files (`.bib`) are auto-detected from `\bibliography{}` or `\addbibresource{}` commands.
- Figure root directories are inferred from `\graphicspath{}` or default to the project root.

## Workflow

1. **Discover project files.** Locate all `.tex` files, `.bib` files, and the graphics path. For multi-file projects, follow `\input{}` and `\include{}` chains starting from the main file (e.g., `COEmain.tex`).

2. **Extract citation keys.** Parse all `.tex` files for `\cite{key}`, `\cite{key1,key2}`, `\parencite{key}`, `\textcite{key}`, `\nocite{key}`, and `\autocite{key}`. Collect into a deduplicated set of citation keys.

3. **Extract BibTeX entry keys.** Parse all `.bib` files for `@article{key,`, `@inproceedings{key,}`, `@book{key,}`, and all other entry types. Collect into a set of defined keys.

4. **Cross-check citations.** Compare the two sets:
   - Keys in `.tex` but not in `.bib`: **UNDEFINED_CITATION**.
   - Keys in `.bib` but never cited: **UNUSED_ENTRY** (informational, not a failure).

5. **Verify figure paths.** Parse all `\includegraphics[...]{path}` commands. For each path:
   - If the path has no extension, check for `.pdf`, `.png`, `.jpg`, `.eps` variants.
   - Resolve relative to `\graphicspath{}` if set.
   - Mark as **MISSING_FIGURE** if no file found on disk.

6. **Detect duplicate labels.** Parse all `\label{key}` definitions across the entire project. If any key appears more than once, mark as **DUPLICATE_LABEL** with file and line information.

7. **Validate cross-references.** Parse all `\ref{key}`, `\eqref{key}`, `\autoref{key}`, `\pageref{key}`, and `\nameref{key}` commands. For each, verify the key exists in the collected label set. Missing keys are **UNDEFINED_REFERENCE**.

8. **Generate audit report.** Write `citation_audit.md` with the results.

## Output

- **citation_audit.md**: Structured report with one section per check, each marked PASS or FAIL.

  ```markdown
  # Citation Verification Audit

  ## Citation Keys
  | Key | Status | Details |
  | --- | --- | --- |
  | smith2020 | PASS | Defined in refs.bib |
  | jones2021 | UNDEFINED_CITATION | Not found in any .bib file |

  ## Figure Paths
  | Path | Status | Details |
  | --- | --- | --- |
  | figures/architecture.pdf | PASS | File exists |
  | figures/results_new.png | MISSING_FIGURE | File not found |

  ## Labels
  | Key | Status | Details |
  | --- | --- | --- |
  | sec:intro | PASS | Defined once in chapter1.tex:42 |
  | fig:results | DUPLICATE_LABEL | Defined in results.tex:15 AND results.tex:87 |

  ## Cross-References
  | Key | Status | Details |
  | --- | --- | --- |
  | tab:comparison | PASS | Points to label in tables.tex |
  | eq:governing | UNDEFINED_REFERENCE | No \label{eq:governing} found |

  ## Summary
  - Citation keys: X defined, Y cited, Z undefined
  - Figure paths: X total, Y missing
  - Labels: X unique, Y duplicate
  - Cross-references: X total, Y undefined
  - Overall: PASS / FAIL
  ```

## Rules

- This skill is read-only: it must not modify any `.tex` or `.bib` files.
- Consider a check FAILED if any item has status UNDEFINED_CITATION, MISSING_FIGURE, DUPLICATE_LABEL, or UNDEFINED_REFERENCE.
- UNUSED_ENTRY (bib entries never cited) is informational and does not cause a FAIL.
- Handle multi-file projects by tracing `\input{}` chains from the main file.
- For paths, respect case sensitivity of the filesystem (Linux is case-sensitive).
- Ignore commented-out lines (`%` prefix) when extracting keys and paths.
- Skip `\cite` commands inside verbatim or listing environments.

## Related Skills

- **paper-compilation**: Run this skill first to fix issues, then compile cleanly.
- **project-file-map**: Provides the file inventory used to locate `.bib` and figure files.
- **claim-evidence-map**: Citation keys are a subset of the evidence tracked in the claim-evidence matrix.
- **submission-qa-gate**: Includes citation verification as one of its pre-submission checks.

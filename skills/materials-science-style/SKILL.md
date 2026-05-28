---
name: materials-science-style
description: Check materials science manuscripts for domain-specific notation conventions, unit consistency, IUPAC/ACS nomenclature, crystal structure notation, and figure/table caption style. Use before submission to catch domain style violations.
argument-hint: [tex-file-or-directory]
---

# Materials Science Style Checker

Audit a materials science manuscript for domain-specific notation, nomenclature, and formatting conventions. Catch style violations that peer reviewers and journal editors commonly flag.

## When to Use

- Before journal submission as a final style pass.
- After major content edits that may have introduced inconsistent notation.
- When adapting a manuscript for a different journal with specific style requirements.
- During the revision of a thesis or dissertation where notation consistency is expected across chapters.

## Input

- **Required**: Path to a `.tex` file or a directory containing the LaTeX project.
- **Optional**: A style specification file (e.g., target journal name or a custom `.yaml` config overriding defaults). If not provided, standard materials science conventions are used.

## Workflow

1. **Scan all `.tex` files**. Recursively find and parse every `.tex` file in the given path.

2. **Check notation conventions**. Verify consistent use of typographic conventions for physical quantities:
   - **Vectors and tensors**: Bold upright (`\mathbf{F}`) or bold italic with arrow (`\vec{\bm{F}}`), but not mixed.
   - **Matrices**: Upright bold or sans-serif bold, consistent throughout.
   - **Variables**: Italic for scalar variables (`$T$`, `$\sigma$`).
   - **Operators and functions**: Upright (`\sin`, `\log`, `\mathrm{d}` for differentials, `\mathrm{Tr}` for trace).
   - **Units**: Always upright, never italic. Use `\mathrm{}`, `\text{}`, or the `siunitx` package (`\unit{}` and `\qty{}`).
   - **Subscripts**: Descriptive subscripts upright (`$T_\mathrm{c}$` for critical temperature), variable subscripts italic (`$T_i$` for indexed temperature).

3. **Check unit consistency**. Verify:
   - SI units are used throughout (exceptions for established non-SI units like eV, angstrom, and atm must be consistent).
   - The `siunitx` package is used for all units, or raw formatting is at least consistent if siunitx is not loaded.
   - No mixing of unit formats (e.g., `nm` in one place and `\nano\meter` in another).
   - Compound units use proper formatting: `J mol^{-1} K^{-1}`, not `J/mol/K` or `J/(mol*K)`.

4. **Check nomenclature (IUPAC/ACS)**. Verify:
   - Chemical compound names follow IUPAC nomenclature (e.g., "sodium chloride", not "NaCl" in running text for first mention; formula acceptable after definition).
   - Standard abbreviations are defined at first use (e.g., "scanning electron microscopy (SEM)").
   - Polymer names follow IUPAC recommendations (e.g., "poly(methyl methacrylate)", not "polymethyl methacrylate").
   - Mineral names are spelled correctly and follow IMA conventions.

5. **Check crystal structure notation**. Verify:
   - Space groups use Hermann-Mauguin notation with proper formatting: `$Pm\bar{3}m$` or `$Fm\bar{3}c$` (not `Pm3m` or `Fm-3c`).
   - Lattice parameters are reported with units: `$a = 3.905$ \angstrom` or `$a = \qty{3.905}{\angstrom}$`.
   - Miller indices use proper LaTeX: `$(hkl)$` for planes, `$[uvw]$` for directions, `$\langle hkl \rangle$` for families.
   - Crystal system names are consistent (e.g., do not mix "tetragonal" and "quadratic").

6. **Check figure captions**. Verify:
   - Multi-panel figures use consistent panel labels: `(a)`, `(b)`, `(c)` with proper formatting.
   - Scale bars are mentioned in the caption for micrographs.
   - Caption structure follows: descriptive title or statement first, then interpretation.
   - Units for axes are stated (e.g., "Intensity (a.u.)" or "Counts").
   - Abbreviations in captions are defined if not previously defined in text.

7. **Check table style**. Verify:
   - Uncertainty format is consistent: either `1.23(4)` or `1.23 +/- 0.04`, but not both.
   - Significant figures are appropriate (not excessive precision beyond measurement capability).
   - Column headers include units in parentheses or brackets.
   - Footnotes use consistent markers (lowercase letters, not mixed with symbols).

8. **Compile findings** (see Output section).

## Output

### `style_check_report.md`

```markdown
## Materials Science Style Check Report

**Files scanned**: 8 `.tex` files
**Issues found**: 23
**By severity**: 4 HIGH, 11 MEDIUM, 8 LOW

---

### HIGH Severity

#### 1. Inconsistent space group notation
- **Location**: `chapters/chapter3.tex` line 72
- **Issue type**: Crystal structure notation
- **Current**: `$Pm3m$`
- **Recommended**: `$Pm\bar{3}m$`
- **Severity**: HIGH
- **Rationale**: Hermann-Mauguin notation requires the overbar. `Pm3m` is ambiguous without it.

#### 2. Unit in italics
- **Location**: `chapters/chapter4.tex` line 115
- **Issue type**: Notation convention
- **Current**: `strain rate of $10^{-3} s^{-1}$`
- **Recommended**: `strain rate of $10^{-3}\,\mathrm{s}^{-1}$` or `strain rate of $\qty{e-3}{\per\second}$`
- **Severity**: HIGH
- **Rationale**: Units must be upright (roman), not italic.

### MEDIUM Severity

#### 3. Undefined abbreviation
- **Location**: `chapters/chapter2.tex` line 34
- **Issue type**: Nomenclature
- **Current**: "XRD pattern shows..."
- **Recommended**: "X-ray diffraction (XRD) pattern shows..." (define at first use)
- **Severity**: MEDIUM

### LOW Severity

#### 4. Mixed uncertainty notation
- **Location**: `chapters/chapter4.tex` table 4.2
- **Issue type**: Table style
- **Current**: Uses both `1.23(4)` and `1.23 +/- 0.04` in the same table
- **Recommended**: Standardize to one format throughout
- **Severity**: LOW
```

## Rules

- **Report, do not auto-fix.** This skill produces a report with recommendations. It does not modify `.tex` files directly.
- **Severity definitions**:
  - **HIGH**: Will likely be flagged by reviewers or cause misinterpretation (wrong notation, missing overbar, italic units).
  - **MEDIUM**: Inconsistent but not technically wrong; should be fixed for professionalism.
  - **LOW**: Style preference; fix if convenient but not blocking.
- **Respect existing conventions.** If the manuscript consistently uses a non-standard but internally consistent convention (e.g., always `$Pm3m$` never `$Pm\bar{3}m$`), report it as LOW severity rather than HIGH.
- **Check siunitx package usage.** If the project already uses `siunitx`, recommend fixes within that framework. If not, suggest adopting it but also provide raw LaTeX alternatives.
- **Do not flag math-mode content as notation issues.** Symbolic variables in equations are exempt from the upright-unit rule within equation environments where the unit is not part of the equation variable.

## Related Skills

- **paper-compilation**: Run after fixing style issues to verify the manuscript still compiles.
- **submission-qa-gate**: Includes this style check as part of a broader pre-submission checklist.
- **section-architecture**: Checks logical flow; complementary to this notation-level check.
- **claim-evidence-map**: Style issues in figure captions can be fixed alongside claim-evidence auditing.

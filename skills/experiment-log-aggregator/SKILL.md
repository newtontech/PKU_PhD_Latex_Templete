---
name: experiment-log-aggregator
description: Aggregate scattered experiment records from notebooks, logs, CSV metrics, and agent caches into a structured experimental_log.md. Inspired by PaperOrchestra's 4-phase aggregation pipeline. Use before claim-evidence-map to consolidate raw experiment evidence.
argument-hint: [project-root-or-search-roots]
---

# Experiment Log Aggregator

Discover, extract, and consolidate scattered experimental records from across the project into a single structured document. Ensures that all raw evidence is gathered and normalized before claim-evidence mapping begins.

## When to Use

- Before running `claim-evidence-map` to ensure all experimental data has been gathered.
- When experiment records are spread across multiple notebooks, CSV files, log outputs, and agent cache directories.
- At the start of a paper writing session when you need a unified view of all available experimental results.
- When onboarding a new collaborator who needs a complete picture of what experiments have been run.

## Input

- **Required**: Path to the project root directory or a space-separated list of search roots.
- The aggregator will recursively scan all provided paths for experiment-related files.

## Workflow

### Phase 1: Discovery

Perform a deterministic scan of the provided directories.

- Use `find` to locate files with the following extensions: `.ipynb`, `.csv`, `.json`, `.log`, `.py`, `.tsv`, `.xlsx`, `.yaml`, `.yml`, `.toml`.
- Also locate files matching common experiment naming patterns: `*experiment*`, `*result*`, `*metric*`, `*output*`, `*log*`, `*trial*`, `*run*`, `*measurement*`, `*data*`.
- Identify agent cache directories (e.g., `.cache/`, `agent_runs/`, `.agent/`) and include their contents.
- Build a discovery index: `{file_path, file_type, size_bytes, last_modified, discovery_method}`.
- Exclude directories: `node_modules`, `.git`, `__pycache__`, `.tox`, `build`, `dist`, `.venv`, `venv`.
- Output the discovery index as `discovery_index.csv`.

### Phase 2: Extraction

Parse each discovered file and extract experiment-relevant content.

- **Notebooks (`.ipynb`)**: Extract cell outputs (text, tables, error messages), markdown cells with observations, and code cells that record parameters or configurations. Record the kernel execution order.
- **CSV/TSV files**: Parse headers and the first 5 rows as a schema preview. If the file is small (< 1000 rows), include all data. For larger files, include summary statistics (mean, std, min, max, count per numeric column).
- **JSON files**: Parse and flatten nested structures up to 3 levels deep. Extract key-value pairs that look like experiment parameters or results (numeric values, arrays of numbers).
- **Log files (`.log`)**: Extract lines matching common experiment output patterns: numeric results, error messages, completion markers, timing information.
- **Python files (`.py`)**: Extract docstrings, comments containing experiment notes, variable assignments that look like hyperparameters or configurations (uppercase variables, dictionary literals with parameter-like keys).
- **YAML/TOML**: Parse as configuration files and extract all key-value pairs as experiment parameters.
- **Strip PII**: Remove names, email addresses, phone numbers, and IP addresses from all extracted content.
- **Mark unverified numbers**: Any numeric value that cannot be traced to an original data source is tagged `[UNVERIFIED]`.
- Output per-file extraction records.

### Phase 3: Synthesis

Consolidate redundant records and resolve conflicts.

- **Deduplication**: Group records by experiment topic (inferred from file names, directory names, and content similarity). Merge records that describe the same experiment from different sources (e.g., a notebook and its output CSV).
- **Conflict detection**: When the same metric appears with different values across sources, flag the conflict. Prefer the most recent value (by file modification time) and the most complete record (most fields populated). Record all conflicting values in the output.
- **Priority labeling**: Assign priority to each consolidated record:
  - **HIGH**: Core experiment results directly supporting the manuscript's main claims (identified by keywords matching abstract/introduction claims, or files in designated `results/` or `experiments/` directories).
  - **MEDIUM**: Supporting experiments, ablation studies, or supplementary results.
  - **LOW**: Exploratory analyses, failed experiments, or preliminary trials.
- **Cross-reference with manuscript**: Scan the manuscript `.tex` files for numerical values and check which have matching experiment records. Flag any numbers in the manuscript that lack a corresponding experiment record.

### Phase 4: Formatting

Produce the structured output documents.

- Organize by experiment topic, then by priority within each topic.
- Use consistent markdown formatting for tables, code blocks, and metadata.
- Include provenance: for every data point, record which file(s) it came from and the extraction timestamp.

## Output

### `experimental_log.md`

The main consolidated experiment record:

```markdown
# Experimental Log

**Project**: [project name from directory]
**Generated**: [ISO 8601 timestamp]
**Source files scanned**: 47
**Records consolidated**: 23
**Unresolved conflicts**: 2

---

## Experiment 1: XRD Phase Analysis

**Priority**: HIGH
**Sources**: `experiments/xrd_analysis.ipynb`, `data/xrd_peaks.csv`
**Date range**: 2024-03-15 to 2024-03-18

### Setup
- Instrument: Bruker D8 Advance
- Scan range: 10-90 degrees (2theta)
- Step size: 0.02 degrees
- Counting time: 1 s/step

### Raw Data
| Sample | 2theta (deg) | Phase | Lattice param a (Angstrom) |
|--------|-------------|-------|---------------------------|
| S1     | 28.4, 47.3  | Cubic | 4.089 [UNVERIFIED]        |
| S2     | 28.6, 47.5  | Cubic | 4.091                     |

### Observations
- Sample S1 lattice parameter from notebook cell 12; CSV shows 4.088. **Conflict**: using notebook value (more recent).
- Phase identification consistent across all samples.

---

## Experiment 2: Mechanical Testing

**Priority**: MEDIUM
**Sources**: `experiments/mechanical/`, `results/hardness.csv`
**Date range**: 2024-04-01 to 2024-04-03

### Setup
- Test type: Vickers microhardness
- Load: 200 gf
- Dwell time: 15 s

### Raw Data
| Sample | HV (mean) | HV (std) | N indentations |
|--------|-----------|----------|----------------|
| S1     | 520       | 18       | 10             |
| S2     | 485       | 22       | 10             |

### Observations
- Data complete and self-consistent.

---

## Unresolved Conflicts

1. **XRD lattice parameter for S1**: Notebook says 4.089 A, CSV says 4.088 A. Both marked [UNVERIFIED]. Author should verify against raw instrument output.
```

### `aggregation_report.md`

A summary of the aggregation process itself:

```markdown
# Aggregation Report

## Discovery Summary
- **Root paths scanned**: 3 (`/project/experiments`, `/project/data`, `/project/notebooks`)
- **Files discovered**: 47
- **By type**: 12 .ipynb, 15 .csv, 8 .json, 5 .log, 4 .py, 3 .yaml
- **Excluded**: 130 files in ignored directories

## Extraction Summary
- **Files successfully parsed**: 44
- **Files with parse errors**: 3 (listed below)
- **Records extracted**: 156

## Synthesis Summary
- **Duplicate groups merged**: 8
- **Conflicts detected**: 2
- **Priority breakdown**: 8 HIGH, 10 MEDIUM, 5 LOW

## Manuscript Cross-Reference
- **Numerical values in manuscript**: 34
- **Values matched to experiment records**: 28
- **Values with no experiment record**: 6 (listed below)

### Unmatched Manuscript Values
1. `chapter4/results.tex` line 89: "4.092 Angstrom" -- no experiment file reports this value.
2. `chapter3/methods.tex` line 45: "99.7% purity" -- no assay record found.

## Parse Errors
1. `experiments/corrupted.ipynb`: Invalid JSON in cell 23. Skipped.
2. `data/binary_output.bin`: Not a recognized format. Skipped.
3. `logs/encoding_error.log`: UTF-8 decode error. Skipped.
```

## Rules

- **Deterministic discovery.** Use `find` with explicit extension lists and name patterns. Do not rely on heuristics or fuzzy matching for file discovery.
- **Never modify source files.** This skill is read-only. It extracts and consolidates but does not alter original experiment records.
- **Prefer most recent data.** When conflicting values exist, default to the most recently modified source. Always document the conflict and all conflicting values.
- **Tag unverified numbers.** Any number that was extracted from a secondary source (e.g., a markdown cell in a notebook that references "we measured X" without showing the raw data) must be tagged `[UNVERIFIED]`.
- **Respect directory structure hints.** Files in directories named `results/`, `final/`, `paper_ready/` are treated as higher confidence than files in `scratch/`, `draft/`, `old/`, or `archive/`.
- **No inference or interpolation.** Do not calculate derived values, averages, or fits. Only report what is explicitly recorded in the source files.
- **PII stripping is mandatory.** All output must be free of personal names, email addresses, and identifying information.

## Related Skills

- **claim-evidence-map**: Consumes `experimental_log.md` as input to map claims to evidence.
- **unsupported-claim-deletion**: Uses the aggregation report to identify manuscript values lacking experiment records.
- **results-consistency**: Cross-checks numerical values between the manuscript and the experiment log.
- **project-file-map**: Provides the initial file inventory that can guide discovery paths.

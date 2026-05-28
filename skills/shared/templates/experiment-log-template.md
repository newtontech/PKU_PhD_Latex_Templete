# Experiment Log Template

Use this template for `experimental_log.md` output from `experiment-log-aggregator`.

```markdown
# Experimental Log

## 1. Experimental Setup

### 1.1 Datasets
- **Dataset A**: [description, source, size, preprocessing]
- **Dataset B**: [description, source, size, preprocessing]

### 1.2 Evaluation Metrics
- [Metric 1]: [definition, higher/lower is better]
- [Metric 2]: [definition, higher/lower is better]

### 1.3 Baselines
- [Baseline 1]: [source, version]
- [Baseline 2]: [source, version]

### 1.4 Implementation Details
- Hardware: [GPU/CPU, memory]
- Software: [framework version, OS]
- Hyperparameters: [learning rate, batch size, epochs]
- Random seeds: [list seeds used]

## 2. Raw Numeric Data

### Table 1: [Experiment Name]
| Method | Metric 1 | Metric 2 | Runtime | Memory |
|--------|----------|----------|---------|--------|
| Baseline 1 | [value] | [value] | [value] | [value] |
| Proposed | [value] | [value] | [value] | [value] |

> Note: Values marked [UNVERIFIED] could not be confirmed from source data.

### Table 2: [Ablation Study]
| Configuration | Metric 1 | Metric 2 |
|---------------|----------|----------|
| Full model | [value] | [value] |
| w/o component A | [value] | [value] |

## 3. Qualitative Observations

### 3.1 Key Findings
- [Finding 1]: [description, supported by which experiment]
- [Finding 2]: [description, supported by which experiment]

### 3.2 Unexpected Results
- [Observation]: [description, possible explanation]

### 3.3 Failure Modes
- [Failure case]: [conditions, frequency, impact]

### 3.4 Ablation Insights
- [Component A]: [impact when removed]
- [Component B]: [impact when removed]

## 4. Figure Provenance

| Figure | Source File | Generation Script | Data File | Last Modified |
|--------|-----------|-------------------|-----------|---------------|
| Fig. 1 | figures/fig1.pdf | scripts/plot_fig1.py | results/exp1.csv | 2024-01-15 |

## 5. Aggregation Report

- Total experiment files scanned: [N]
- High priority files: [N]
- Medium priority files: [N]
- Unverified values: [N]
- Conflicting data points: [N]
- Aggregation date: [date]
```

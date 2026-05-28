---
name: manuscript-autorater
description: Score manuscript quality on 6 axes with anti-inflation rules and halt conditions. Inspired by PaperOrchestra's autorater. Use after each revision round to track whether changes improve or degrade the manuscript.
argument-hint: [tex-file-or-directory]
---

# Manuscript Autorater Skill

Use this skill to score the manuscript on 6 weighted axes after each revision round. It prevents score inflation, detects quality regressions, and halts when revisions stop producing meaningful improvements.

## Inputs

- Manuscript `.tex` files or the root directory containing them.
- Optional: previous `manuscript_scores.md` for trend comparison.
- Optional: claim-evidence matrix from `claim-evidence-map-skill`.
- Optional: results consistency audit from `results-consistency-skill`.

## 6-Axis Scoring Rubric

Each axis is scored 0--100. The weighted sum produces the overall score.

### Axis 1: Claim-Evidence Alignment (weight: 25%)

Measures whether every scientific claim traces to verified evidence.

| Score Range | Criteria |
| --- | --- |
| 90--100 | All claims fully verified against sources. No unsupported statements. Evidence IDs documented for every claim. |
| 70--89 | Most claims verified. Minor gaps in supporting evidence for secondary claims. No overclaims. |
| 50--69 | Core claims verified but peripheral claims lack sources. Some quantitative claims reference approximate or incomplete evidence. |
| 30--49 | Multiple claims lack direct evidence. Overclaims or exaggerated novelty statements present. |
| 0--29 | Major claims are unsupported or contradicted by available evidence. Systematic overclaiming. |

### Axis 2: Structural Coherence (weight: 20%)

Measures IMRaD or thesis structure integrity, logical flow, and section balance.

| Score Range | Criteria |
| --- | --- |
| 90--100 | Clean IMRaD/thesis structure. Each section has a clear purpose. Transitions are logical. Section lengths are balanced for the venue. |
| 70--89 | Structure is sound with minor flow issues. One section may be slightly over- or under-developed. |
| 50--69 | Structure is recognizable but sections drift from their purpose. Notable repetition or gaps in the narrative arc. |
| 30--49 | Structural problems: missing sections, misplaced content, or severe imbalance. Reader cannot follow the argument chain. |
| 0--29 | No discernible structure. Content is disorganized, sections are missing or empty. |

### Axis 3: Reproducibility (weight: 20%)

Measures methods completeness, parameter reporting, seeds, versions, and protocol detail.

| Score Range | Criteria |
| --- | --- |
| 90--100 | All parameters, hyperparameters, software versions, seeds, hardware, and protocols fully specified. Another researcher could replicate the work. |
| 70--89 | Key parameters documented. Minor omissions that a domain expert could reasonably infer. |
| 50--69 | Core setup described but missing specifics such as learning rate schedule, data splits, or random seeds. |
| 30--49 | Incomplete methods section. Critical parameters omitted. Reproducibility would require significant guesswork. |
| 0--29 | Methods are too vague to reproduce. No parameter values, no software versions, no protocol detail. |

### Axis 4: Clarity and Precision (weight: 15%)

Measures wording precision, absence of vague language, and consistent terminology.

| Score Range | Criteria |
| --- | --- |
| 90--100 | Every sentence is precise. No vague qualifiers ("very", "significantly" without quantification). Terminology is consistent throughout. |
| 70--89 | Generally clear prose with occasional vague spots. One or two inconsistent terms. |
| 50--69 | Readable but contains multiple vague statements, unquantified comparisons, or shifting terminology. |
| 30--49 | Frequently imprecise. Key concepts are ambiguously defined. Reader must guess intended meaning in places. |
| 0--29 | Prose is unclear throughout. Undefined jargon, contradictory statements, or pervasive vagueness. |

### Axis 5: Citation Rigor (weight: 10%)

Measures citation completeness, accuracy, and faithful representation of cited work.

| Score Range | Criteria |
| --- | --- |
| 90--100 | All citations verified against originals. No ghost citations. Each cited work is represented faithfully. |
| 70--89 | Citations are mostly accurate. One or two may need verification. No ghost citations detected. |
| 50--69 | Some citations lack verification. Possible misrepresentation of one or two cited findings. |
| 30--49 | Multiple ghost citations or unverified references. At least one clear misattribution. |
| 0--29 | Citation integrity is poor. Ghost citations, fabricated references, or systematic misrepresentation. |

### Axis 6: Domain Conventions (weight: 10%)

Measures adherence to notation, units, nomenclature, and figure/table style expected by the target domain or venue.

| Score Range | Criteria |
| --- | --- |
| 90--100 | Notation is consistent. Units follow standards. Figures and tables follow domain style guides. Nomenclature is correct. |
| 70--89 | Minor convention deviations. One or two notation inconsistencies. |
| 50--69 | Several convention violations. Figure or table formatting does not match venue expectations. |
| 30--49 | Notable disregard for domain conventions. Reader would find the presentation unfamiliar or confusing. |
| 0--29 | Systematic violations of domain standards. Notation is non-standard, units are missing or wrong. |

## Overall Score

```
overall = sum(axis_score * axis_weight)
weights: [0.25, 0.20, 0.20, 0.15, 0.10, 0.10]
```

The overall score ranges from 0 to 100.

## Anti-Inflation Rules

Score inflation undermines the purpose of tracking quality across revision rounds. The following rules prevent it.

### Rule 1: Evidence Required for Score Increases

A score on any axis cannot increase unless the rater cites the specific textual change that justifies the improvement. Vague justifications such as "improved overall" are rejected.

Required format for any score increase:

```
Axis: Claim-Evidence Alignment
Previous score: 65
New score: 72
Evidence: Paragraph 3, Section 4.2 now cites Table S3 for the 12.3% improvement
claim. Previous version had no source for this claim.
```

### Rule 2: No Averaging Across Axes

Each axis is scored independently. A high score on one axis cannot compensate for a low score on another when determining per-axis trends.

### Rule 3: Conservative Scoring

When evidence is ambiguous or incomplete, score toward the lower bound of the relevant range. Do not round up.

## Halt Conditions

The autorater enforces three halt conditions to prevent endless or counterproductive revision loops.

### Halt 1: Overall Score Drop

If the overall score decreases compared to the previous round:

- Status: **REVERT**
- Action: Undo the changes from this revision round. Restore the previous manuscript version.
- Report the specific axes that regressed and by how much.

### Halt 2: Tied Overall but Sub-Axis Regression

If the overall score is unchanged or within a 2-point tolerance but any sub-axis score drops by 5 or more points:

- Status: **REVERT**
- Action: Undo the changes from this revision round.
- Report the regressed sub-axes even though the overall score held.

### Halt 3: Plateau

If after 3 consecutive revision rounds the overall score has improved by fewer than 2 points total:

- Status: **PLATEAU**
- Action: Stop the revision loop. Further revisions are unlikely to produce meaningful quality gains.
- Report the plateau duration and recommend either submitting in current form or restructuring.

## Output

Write `manuscript_scores.md` containing:

```markdown
# Manuscript Quality Scores

## Round [N]

| Axis | Score | Weight | Evidence for Score | Weaknesses |
| --- | --- | --- | --- | --- |
| Claim-Evidence Alignment | ... | 0.25 | ... | ... |
| Structural Coherence | ... | 0.20 | ... | ... |
| Reproducibility | ... | 0.20 | ... | ... |
| Clarity & Precision | ... | 0.15 | ... | ... |
| Citation Rigor | ... | 0.10 | ... | ... |
| Domain Conventions | ... | 0.10 | ... | ... |

**Overall Score:** [weighted sum]

**Halt Status:** [CONTINUE / REVERT / PLATEAU]

## Trend

| Round | Overall | Alignment | Coherence | Reproducibility | Clarity | Citations | Conventions |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | ... | ... | ... | ... | ... | ... | ... |
| N | ... | ... | ... | ... | ... | ... | ... |
```

The `Evidence for Score` column must cite specific manuscript passages, sections, or line numbers. The `Weaknesses` column must list concrete issues that lower the score from 100.

## Usage

1. Run this skill after each revision round.
2. Compare current scores against the previous `manuscript_scores.md`.
3. If halt condition triggers, follow the prescribed action.
4. Archive each round's scores for trend analysis.

## Dependencies

- `claim-evidence-map-skill`: provides the claim-evidence matrix for scoring Axis 1.
- `results-consistency-skill`: provides consistency audit data for scoring Axis 1 and Axis 3.
- `paper-compilation-skill`: ensures the manuscript compiles cleanly before scoring begins.

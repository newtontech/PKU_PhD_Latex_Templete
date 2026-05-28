---
name: multi-reviewer-audit
description: Run a 5-perspective independent review of the manuscript covering editorial fit, methodology, domain expertise, cross-disciplinary impact, and adversarial argument testing. Inspired by academic-research-skills multi-reviewer approach. Use for pre-submission quality check or simulating peer review.
argument-hint: [tex-file-or-directory]
---

# Multi-Reviewer Audit Skill

Use this skill to simulate a full peer review panel. Five independent reviewers evaluate the manuscript from distinct perspectives. Their reviews are consolidated into a unified action report. Use this before submission or when revising based on real reviewer feedback.

## Inputs

- Manuscript `.tex` files or the root directory containing them.
- Optional: claim-evidence matrix from `claim-evidence-map-skill`.
- Optional: results consistency audit from `results-consistency-skill`.
- Optional: target venue or journal name for editorial fit assessment.
- Optional: manuscript scores from `manuscript-autorater-skill`.

## Independence Rule

Each reviewer operates independently. No reviewer sees another reviewer's output until all five reviews are complete. This prevents anchoring bias and ensures genuine multi-perspective coverage.

## Reviewer Roles

### Reviewer 1: Editor

**Focus:** Overall manuscript quality, venue fit, and editorial assessment.

**Evaluation criteria:**

- Does the manuscript fit the scope and aims of the target venue?
- Is the title accurate, informative, and appropriately scoped?
- Is the abstract a faithful summary of contributions and results?
- Does the manuscript present a clear and original contribution?
- Is the writing quality sufficient for the target readership?
- Are the figures and tables publication-ready?
- Does the manuscript meet formatting and length requirements?

**Scoring rubric:**

| Score Range | Meaning |
| --- | --- |
| 90--100 | Ready for submission. Minor polish at most. |
| 70--89 | Solid work with manageable issues. |
| 50--69 | Needs significant revision before submission. |
| 30--49 | Major concerns that may warrant rejection. |
| 0--29 | Not suitable for the target venue in current form. |

**Output fields:** `score`, `venue_fit`, `originality`, `presentation_quality`, `specific_issues`, `recommendation`.

### Reviewer 2: Methodology Reviewer

**Focus:** Experimental design, statistical validity, and reproducibility.

**Evaluation criteria:**

- Is the experimental design sound and appropriate for the research questions?
- Are statistical methods correctly applied and reported?
- Are sample sizes, effect sizes, and confidence intervals adequate?
- Are baselines and comparison methods appropriate and fair?
- Is the evaluation protocol complete (metrics, datasets, splits, seeds)?
- Can the experiments be reproduced from the methods section alone?
- Are limitations of the methodology honestly discussed?

**Scoring rubric:**

| Score Range | Meaning |
| --- | --- |
| 90--100 | Rigorous methodology. Fully reproducible. |
| 70--89 | Sound approach with minor methodological gaps. |
| 50--69 | Adequate design but notable gaps in rigor or reporting. |
| 30--49 | Significant methodological weaknesses. |
| 0--29 | Fatally flawed experimental design or analysis. |

**Output fields:** `score`, `design_soundness`, `statistical_validity`, `reproducibility`, `baseline_appropriateness`, `specific_issues`, `recommendation`.

### Reviewer 3: Domain Expert

**Focus:** Literature coverage, technical accuracy, and contribution significance.

**Evaluation criteria:**

- Is the literature review comprehensive and current?
- Are key prior works correctly cited and fairly represented?
- Is the technical content accurate for the domain?
- Does the work advance the state of the art in a meaningful way?
- Are the claimed contributions well-supported by the results?
- Is the domain-specific terminology used correctly?
- Are the results interpreted correctly within the domain context?

**Scoring rubric:**

| Score Range | Meaning |
| --- | --- |
| 90--100 | Strong contribution with comprehensive and accurate domain coverage. |
| 70--89 | Solid contribution with minor gaps in literature or interpretation. |
| 50--69 | Adequate but misses important prior work or misinterprets some results. |
| 30--49 | Weak contribution or significant technical inaccuracies. |
| 0--29 | Does not advance the field or contains fundamental domain errors. |

**Output fields:** `score`, `literature_coverage`, `technical_accuracy`, `contribution_significance`, `interpretation_quality`, `specific_issues`, `recommendation`.

### Reviewer 4: Perspective Reviewer

**Focus:** Cross-disciplinary connections, practical impact, and broader relevance.

**Evaluation criteria:**

- Does the work connect to adjacent fields or disciplines?
- What is the practical impact or application potential?
- Are implications for practitioners or policymakers discussed?
- Does the work generalize beyond the specific experimental setting?
- Are the findings relevant to broader scientific or societal questions?
- Would researchers in other fields find this work useful or interesting?
- Are limitations in generalizability acknowledged?

**Scoring rubric:**

| Score Range | Meaning |
| --- | --- |
| 90--100 | Broad impact with clear cross-disciplinary relevance. |
| 70--89 | Meaningful connections to adjacent areas. |
| 50--69 | Limited but present broader relevance. |
| 30--49 | Narrow scope with little external relevance. |
| 0--29 | No discernible impact beyond the immediate experimental setting. |

**Output fields:** `score`, `cross_disciplinary_connections`, `practical_impact`, `generalizability`, `broader_relevance`, `specific_issues`, `recommendation`.

### Reviewer 5: Devil's Advocate

**Focus:** Challenge core arguments, find logical gaps, and test assumptions.

**Evaluation criteria:**

- What are the weakest links in the argument chain?
- Are there alternative explanations for the observed results?
- What assumptions underpin the conclusions, and are they justified?
- Could the results be an artifact of the experimental setup?
- Are there confounds that were not controlled or discussed?
- Is the claimed novelty genuine, or is it incremental?
- What would a hostile reviewer attack first?

**Scoring rubric:**

| Score Range | Meaning |
| --- | --- |
| 90--100 | Arguments are airtight. No exploitable weaknesses found. |
| 70--89 | Minor vulnerabilities that are easy to address. |
| 50--69 | Notable gaps that a hostile reviewer could exploit. |
| 30--49 | Serious logical flaws in the argument chain. |
| 0--29 | Core arguments do not hold up under scrutiny. |

**Output fields:** `score`, `weakest_arguments`, `alternative_explanations`, `untested_assumptions`, `potential_artifacts`, `specific_issues`, `recommendation`.

## Anti-Patterns

To ensure the review is useful and actionable, the following patterns are forbidden.

### No Duplicate Criticisms

If two or more reviewers flag the same issue with the same reasoning, consolidate it into a single entry in the final report. Tag it with all reviewers who raised it to show consensus.

### Feedback Must Cite Specific Passages

Every criticism must reference a specific section, paragraph, figure, table, or equation. Generic feedback such as "the methodology is weak" without citing where and why is rejected.

Example of acceptable feedback:

```
Section 3.2, paragraph 2: The claim that "our method significantly outperforms
the baseline" is not supported by the data in Table 2. The difference (0.83 vs
0.81) is within the standard deviation and no significance test is reported.
```

### No Vague Recommendations

Every recommendation must state what to change, where to change it, and what the expected outcome is. "Improve the introduction" is not acceptable. "Add a paragraph in Section 1, after paragraph 3, that positions the work relative to Smith et al. (2024) and clarifies the gap in prior approaches" is acceptable.

## Severity Classification

Each issue is classified by severity:

| Severity | Meaning | Action |
| --- | --- | --- |
| CRITICAL | Would likely cause rejection. Must fix before submission. | Block submission. |
| HIGH | Significant concern that multiple reviewers would raise. Should fix. | Strong recommendation to fix. |
| MEDIUM | Notable issue that weakens the manuscript. Consider fixing. | Fix if time permits. |
| LOW | Minor improvement opportunity. Optional. | Fix if trivial, otherwise note for future. |

Severity is assigned independently by each reviewer. The consolidated report uses the highest severity assigned by any reviewer for each unique issue.

## Consolidated Report

After all five reviews are complete, consolidate into a unified report.

### Consolidation Rules

1. Merge duplicate issues, tagging all originating reviewers.
2. Assign the highest severity from among the reviewers who raised the issue.
3. Order issues by severity: CRITICAL first, then HIGH, then MEDIUM, then LOW.
4. Within each severity level, order by the number of reviewers who raised the issue (most consensus first).

### Issue Schema

Each consolidated issue includes:

| Field | Meaning |
| --- | --- |
| `issue_id` | Stable ID such as `I001` |
| `severity` | CRITICAL / HIGH / MEDIUM / LOW |
| `reviewers` | List of reviewers who raised this issue |
| `location` | Specific section, paragraph, figure, table, or equation |
| `description` | What the problem is |
| `evidence` | Specific passage or data point cited |
| `recommendation` | What to change, where, and expected outcome |

## Output

Write `review_report.md` containing:

```markdown
# Multi-Reviewer Audit Report

## Manuscript: [title]

## Per-Reviewer Summaries

### Editor (Reviewer 1)
- Score: [0--100]
- Venue Fit: [assessment]
- Originality: [assessment]
- Presentation Quality: [assessment]
- Recommendation: [accept / minor revision / major revision / reject]

### Methodology Reviewer (Reviewer 2)
- Score: [0--100]
- Design Soundness: [assessment]
- Statistical Validity: [assessment]
- Reproducibility: [assessment]
- Recommendation: [accept / minor revision / major revision / reject]

### Domain Expert (Reviewer 3)
- Score: [0--100]
- Literature Coverage: [assessment]
- Technical Accuracy: [assessment]
- Contribution Significance: [assessment]
- Recommendation: [accept / minor revision / major revision / reject]

### Perspective Reviewer (Reviewer 4)
- Score: [0--100]
- Cross-Disciplinary Connections: [assessment]
- Practical Impact: [assessment]
- Generalizability: [assessment]
- Recommendation: [accept / minor revision / major revision / reject]

### Devil's Advocate (Reviewer 5)
- Score: [0--100]
- Weakest Arguments: [list]
- Alternative Explanations: [list]
- Untested Assumptions: [list]
- Recommendation: [accept / minor revision / major revision / reject]

## Reviewer Score Summary

| Reviewer | Role | Score | Recommendation |
| --- | --- | --- | --- |
| 1 | Editor | ... | ... |
| 2 | Methodology | ... | ... |
| 3 | Domain Expert | ... | ... |
| 4 | Perspective | ... | ... |
| 5 | Devil's Advocate | ... | ... |
| **Average** | | ... | |

## Consolidated Issues

### CRITICAL

| ID | Location | Description | Reviewers | Recommendation |
| --- | --- | --- | --- | --- |
| I001 | ... | ... | ... | ... |

### HIGH

| ID | Location | Description | Reviewers | Recommendation |
| --- | --- | --- | --- | --- |
| I... | ... | ... | ... | ... |

### MEDIUM

| ID | Location | Description | Reviewers | Recommendation |
| --- | --- | --- | --- | --- |
| I... | ... | ... | ... | ... |

### LOW

| ID | Location | Description | Reviewers | Recommendation |
| --- | --- | --- | --- | --- |
| I... | ... | ... | ... | ... |

## Action Items

Ordered by priority:

1. [CRITICAL] ...
2. [HIGH] ...
3. [MEDIUM] ...
4. [LOW] ...
```

## Usage

1. Run this skill as a pre-submission check or after major revisions.
2. Review the consolidated issues starting with CRITICAL items.
3. Address issues in priority order.
4. Re-run after addressing issues to verify improvement.
5. Compare reviewer scores across runs to track improvement.

## Dependencies

- `claim-evidence-map-skill`: provides claim-evidence data for Methodology and Domain Expert reviewers.
- `results-consistency-skill`: provides consistency data for Methodology Reviewer.
- `manuscript-autorater-skill`: provides quality scores as additional reviewer context.

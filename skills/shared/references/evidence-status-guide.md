# Evidence Status Guide

## Status Definitions

| Status | Meaning | Allowed Action |
|--------|---------|----------------|
| `VERIFIED` | Direct evidence from experiment file, code output, figure, log, author note, or verified literature | Can write into manuscript with evidence ID |
| `WEAKLY_SUPPORTED` | Indirect or incomplete support | Lower claim strength, add conditions, or move to limitations |
| `MISSING` | No evidence found | Do not add content; only TODO or comment |
| `CONTRADICTED` | Evidence conflicts with manuscript statement | Block until resolved: fix source, fix manuscript, or escalate to author |
| `NEEDS_HUMAN_DECISION` | Requires scientific judgment, policy choice, or confidential context | Present options with pros/cons; do not decide |

## Evidence Classes

| Class | Source |
|-------|--------|
| `MANUSCRIPT_SUPPORTED` | Already stated in the manuscript |
| `EVIDENCE_SUPPORTED` | Present in scripts, logs, notebooks, metadata, or author notes |
| `REFERENCE_SUPPORTED` | Supported by a cited protocol, standard, or verified DOI |
| `MISSING` | Needed for completeness but absent |
| `INCONSISTENT` | Manuscript and evidence disagree |

## Revision Actions

| Action | When to Use |
|--------|-------------|
| `keep` | Claim is VERIFIED and well-stated |
| `weaken` | WEAKLY_SUPPORTED; narrow scope or add hedging |
| `delete` | MISSING or CONTRADICTED with no path to resolution |
| `move_to_limitation` | WEAKLY_SUPPORTED; acknowledge as limitation |
| `add_evidence` | Evidence exists but is not cited in manuscript |
| `ask_author` | NEEDS_HUMAN_DECISION; present options |

## Prohibited Actions

- Never invent experiments, datasets, baselines, or numerical results
- Never generate citations or DOIs that do not exist
- Never strengthen a WEAKLY_SUPPORTED claim
- Never silently rewrite without leaving a trace
- Never copy private evidence into public documentation

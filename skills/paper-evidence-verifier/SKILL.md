---
name: paper-evidence-verifier
description: Verify that every VERIFIED claim in the claim-evidence matrix traces to real, existing evidence files. Detect broken evidence chains, circular references, and phantom evidence. Use after claim-evidence-map to validate the evidence binding.
argument-hint: [claim-evidence-matrix-path]
---

# Paper Evidence Verifier Skill

Use this skill to validate the claim-evidence matrix after it is built. It ensures that every claim marked as VERIFIED actually points to evidence files that exist on disk, that no evidence chain loops back on itself, and that no phantom files are referenced.

## When to Use

- Immediately after running claim-evidence-map, before any revision work begins.
- Before submission to confirm every VERIFIED claim has a real evidence trail.
- After moving, renaming, or reorganizing project files that might break evidence paths.
- When auditing reviewer responses that cite specific experimental results.

## Input

- **claim-evidence-matrix-path**: Path to `claim_evidence_matrix.csv` (or `.md`) produced by the claim-evidence-map skill.
- The project root is inferred from the matrix location or provided explicitly.
- `project_file_inventory.md` is used as the canonical list of known project files.

## Workflow

1. **Load the matrix.** Read `claim_evidence_matrix.csv`. Parse each row, extracting `claim_id`, `claim_text`, `support_level`, `evidence_ids`, and `location`.

2. **Filter to VERIFIED claims.** Only claims with `support_level` equal to `VERIFIED` enter the verification pipeline. Claims with other statuses (WEAKLY_SUPPORTED, MISSING, CONTRADICTED, NEEDS_HUMAN_DECISION) are noted but skipped for evidence file verification.

3. **Resolve evidence IDs to file paths.** For each VERIFIED claim, expand `evidence_ids` into concrete file paths using the project file inventory. Each ID (e.g., `F003`, `D012`, `E001`) maps to a path in `project_file_inventory.md`.

4. **Verify file existence.** For every resolved path, check that the file exists on disk:
   - If the file exists: mark **VERIFIED**.
   - If the file does not exist: mark **BROKEN** and record the missing path.

5. **Detect circular references.** For each evidence file that is itself a manuscript source (type `manuscript`), check whether it references back to the claim's location. Build a directed graph of claim-to-evidence edges and detect cycles:
   - If a cycle is found (claim A -> evidence B -> claim A): mark **CIRCULAR**.
   - Cycles longer than 2 hops are also detected by graph traversal.

6. **Detect phantom evidence.** Compare all evidence IDs referenced in the matrix against the `project_file_inventory.md`:
   - IDs in the matrix but not in the inventory: mark **PHANTOM**.
   - This catches cases where an ID was fabricated or the inventory is stale.

7. **Generate verification report.** Write `evidence_verification_report.md`.

## Output

- **evidence_verification_report.md**: Per-claim verification status with details.

  ```markdown
  # Evidence Verification Report

  ## Verification Summary
  - Total VERIFIED claims: X
  - Evidence chains intact: Y
  - Broken chains: Z
  - Circular references: W
  - Phantom evidence: V
  - Overall: PASS / FAIL

  ## Per-Claim Results

  | Claim ID | Status | Evidence IDs | Detail |
  | --- | --- | --- | --- |
  | C001 | VERIFIED | F003, D012 | All evidence files exist |
  | C005 | BROKEN | F099 | F099 -> figures/plot_v2.pdf not found |
  | C012 | CIRCULAR | M003 | C012 in results.tex -> M003 (results.tex) -> C012 |
  | C018 | PHANTOM | E999 | E999 not found in project_file_inventory.md |

  ## Broken Evidence Chains
  (Details for each BROKEN claim with expected paths and resolution suggestions)

  ## Circular References
  (Cycle path for each CIRCULAR claim)

  ## Phantom Evidence
  (List of IDs referenced but not in inventory)
  ```

## Rules

- A single BROKEN, CIRCULAR, or PHANTOM finding on any VERIFIED claim causes the overall result to be FAIL.
- Only VERIFIED claims are checked. WEAKLY_SUPPORTED and MISSING claims are already flagged by claim-evidence-map.
- The skill must not modify the matrix or any evidence files; it is read-only.
- If `project_file_inventory.md` is missing, the skill should note this and treat all file-existence checks as UNKNOWN rather than failing silently.
- Circular reference detection must handle transitive chains (A -> B -> C -> A), not just direct two-node cycles.
- Evidence IDs that map to DOIs or external URLs are marked VERIFIED by default (file existence does not apply); optionally, their HTTP reachability can be checked.

## Related Skills

- **claim-evidence-map**: Produces the input matrix that this skill verifies.
- **project-file-map**: Produces `project_file_inventory.md` used to resolve evidence IDs to paths.
- **experiment-folder-indexer**: Builds the evidence ledger that feeds into the file inventory.
- **results-consistency**: Runs after evidence verification to check numerical consistency.
- **submission-qa-gate**: Includes evidence verification as a pre-submission check.

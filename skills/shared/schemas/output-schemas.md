# Output Schemas

All revision skills produce structured outputs in `revision_outputs/`.

## project_file_inventory.md

```markdown
| file_id | path | type | role | provenance | sensitivity | readiness | notes |
|---------|------|------|-----|-----------|-------------|-----------|-------|
| M001 | COEmain.tex | manuscript | main entry | author | public | READY | |
```

## claim_evidence_matrix.csv

```csv
claim_id,location,claim_text,claim_type,evidence_ids,support_level,risk,recommended_action,notes
C001,body/COEintroduction.tex:L23,"We achieve 95% efficiency",quantitative,E003,E005,VERIFIED,low,keep,
```

## evidence_ledger.jsonl

```json
{"id":"E001","path":"experiments/exp1/results.json","type":"processed_data","status":"READY","description":"Efficiency metrics for experiment 1","last_modified":"2024-01-15"}
```

## consistency_audit.md

```markdown
| finding_id | location | manuscript_value | source_value | source_evidence | status | severity | action | notes |
|------------|----------|-----------------|-------------|----------------|--------|----------|--------|-------|
| R001 | body/COEchap3.tex:L45 | 0.83 | 0.87 | E003 | MISMATCH | blocker | correct | Table 2 says 0.87 |
```

## unsupported_claims.md

```markdown
| claim_id | location | current_text | support_level | proposed_action | proposed_text | rationale |
|----------|----------|--------------|---------------|----------------|---------------|-----------|
| C005 | abstract:L3 | "significantly outperforms" | MISSING | weaken | "may offer improvements in" | No comparison experiment found |
```

## manuscript_scores.md

```markdown
| axis | score | weight | weighted | evidence | weaknesses |
|------|-------|--------|----------|----------|-----------|
| Claim-Evidence Alignment | 72 | 0.25 | 18.0 | 3 claims MISSING, 2 WEAKLY_SUPPORTED | Abstract overclaims without evidence |
```

## submission_qa_report.md

```markdown
| category | item | status | details |
|----------|------|--------|---------|
| Compilation | clean build | PASS | 0 errors, 2 warnings |
| References | all cited | FAIL | 3 keys undefined |
```

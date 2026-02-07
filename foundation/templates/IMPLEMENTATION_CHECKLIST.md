# Implementation Checklist Template

Copy this template into every implementation proposal. Fill in every section before requesting approval.

---

```
## Implementation Checklist

### Task Summary
[What is being implemented, in one sentence]

### Scope
[frontend / backend / fullstack] — [one sentence explaining why]

### Blast Radius
- Files: [list]
- DB impact: [yes/no — if yes, list tables]
- External integrations: [yes/no — if yes, list services]
- Rollback: [1-2 steps]
- High-Impact? [yes/no]
  - Triggers: [files>5 | DB migration | critical module | public API change]

### Source of Truth Check
- Shared state: [yes/no]
- Persisted in DB: [yes/no/N/A]
- State Protocol: [yes/no/N/A]

### Tests & Verification
- Type: [smoke / curl / unit / migration]
- Command or plan: [specific command or description]

### Secrets & Safety
- Secrets in diff: [no]
- Placeholders: [yes/N/A]
- Dev endpoints: [no / yes — with guards listed]

### Safe Defaults
- Feature-flagged: [yes/N/A]
- Backward compatible: [yes/N/A]
- Default no-op: [yes/N/A]

### Proof / Assumptions
- [list grep results or assumptions]

### Risk Level
- [ ] Low (documentation, styling, additive)
- [ ] Medium (logic changes, new endpoints)
- [ ] High (DB schema, external APIs, multi-file refactors)

If High-Impact is yes:
⚠ HIGH-IMPACT: [trigger 1, trigger 2, ...]

### Next Step
Awaiting human approval.
```

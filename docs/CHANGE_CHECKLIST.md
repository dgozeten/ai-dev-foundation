# Change Checklist

This checklist MUST be completed for every implementation response. No exceptions.

Copy this checklist into your response and fill in each item. An empty checklist item is a gate failure.

---

## Checklist

### 1. Blast Radius

- [ ] **Files affected:** (list all files to be created, modified, or deleted)
- [ ] **DB/migration impact:** Yes / No
  - If yes: (list tables and columns)
- [ ] **External integrations affected:** Yes / No
  - If yes: (list APIs, webhooks, services)
- [ ] **Rollback plan:** (1-2 steps to undo this change)
- [ ] **High-Impact?** Yes / No
  - [ ] Trigger: files > 5
  - [ ] Trigger: DB migration or schema change
  - [ ] Trigger: critical module (auth, payment, ledger, security)
  - [ ] Trigger: public API contract change

### 2. Source of Truth

- [ ] **Shared state involved:** Yes / No
- [ ] **If yes, is state persisted in DB?** Yes / No
- [ ] **State Protocol used (`requestId`, `rev`, `expectedRev`)?** Yes / No / N/A
- [ ] **UI-only state change for shared data?** No (if yes, this is a violation)

### 3. Tests & Verification

At least one MUST be checked:

- [ ] **Smoke test command:** (e.g., `curl http://localhost:3100/health`)
- [ ] **curl verification:** (e.g., `curl -X POST ... | jq .ok`)
- [ ] **Unit test plan:** (describe what should be tested)
- [ ] **Migration verify query:** (e.g., `SELECT count(*) FROM ...`)

### 4. Secrets & Safety

- [ ] **Any secrets or tokens in the diff?** No (if yes, STOP)
- [ ] **Example values clearly marked as placeholders?** Yes / N/A
- [ ] **Any new dev-only endpoints?** No
  - If yes: env flag + secret header + non-prod guard required

### 5. Safe Defaults

- [ ] **New capability feature-flagged or opt-in?** Yes / N/A
- [ ] **Backward compatible?** Yes / N/A
- [ ] **Default behavior unchanged?** Yes / N/A
- [ ] **Deprecation documented if renaming?** Yes / N/A

### 6. Proof / Assumptions

- [ ] **All referenced files verified via grep/search?** Yes
- [ ] **Any assumptions labeled?** (list them, or "none")

### 7. Approval

- [ ] **Human approval received?** (STOP here if not)

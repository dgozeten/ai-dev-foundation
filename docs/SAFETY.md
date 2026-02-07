# Safety Rules

These rules are non-negotiable. They apply to every change, every session, every contributor.

---

## 1. Secrets & Config Hygiene

Never commit secrets. Not in code, not in comments, not in documentation.

- Example secrets must use obvious placeholders: `your-secret-here`, `REPLACE_ME`, `<placeholder>`
- Never use real-looking values like `sk-abc123...` even as examples
- Never log tokens or keys. If absolutely unavoidable, mask all but the last 4 characters
- Environment variables must be read from `.env` files that are gitignored
- `.env.example` files must contain only placeholders, never real values

### Dev-Only Endpoints

Any endpoint that exists only for development purposes must require ALL of:

1. **Environment flag** — `NODE_ENV !== 'production'` or equivalent
2. **Secret header** — `X-Dev-Token` with a value that is not committed to the repository
3. **Non-production guard** — endpoint must refuse to execute if production environment is detected

---

## 2. Safe Defaults

Every new capability must follow these rules:

- **Feature-flagged or opt-in.** The feature must be explicitly enabled. Default is off.
- **Backward compatible.** Existing consumers, APIs, and integrations continue to work without modification.
- **Default no-op.** If the feature is not enabled, it does nothing. No side effects, no logging, no network calls.
- **Documented deprecation.** If renaming or replacing an endpoint, function, or configuration key, the old name must continue to work with a deprecation notice. Silent removal is never acceptable.

### Why This Matters

A new feature that changes default behavior is a breaking change. Breaking changes in infrastructure are unacceptable unless explicitly versioned and communicated.

---

## 3. Hallucination Guard

AI-assisted development introduces a specific risk: the AI may reference things that do not exist.

### Rules

If the AI references a file, route, table, column, or function, it MUST do one of:

1. **Provide proof.** Show the grep output, search result, or file line that confirms its existence.
2. **Label it as an assumption.** Explicitly state "ASSUMPTION: I believe X exists at Y — please confirm" and STOP until confirmed.

### Prohibited Actions

- Do not invent file paths
- Do not reference database columns without confirming the schema
- Do not assume an endpoint exists without checking the router or server file
- Do not cite line numbers without having viewed the file
- Do not claim a package is installed without checking `package.json` or equivalent

### Consequence

A hallucinated reference that leads to a runtime error is treated as a critical failure, equivalent to bypassing the Decision Gate.

---

## 4. Blast Radius

Before any change, the blast radius must be assessed:

| Dimension | Question |
|---|---|
| **Files** | How many files will be created, modified, or deleted? |
| **Database** | Are any tables, columns, indexes, or constraints affected? |
| **Integrations** | Are any external APIs, webhooks, or third-party services affected? |
| **Rollback** | Can this change be undone in 1-2 steps? |

If the blast radius exceeds 5 files or touches database schema, the change is classified as **high-impact** and requires explicit human acknowledgment before proceeding.

---

## 5. Source of Truth

- UI is a display layer. It is never the source of truth for shared state.
- If multiple users, services, or sessions can read the same state, that state must live in the database.
- Mutations to shared state must go through the State Protocol (`requestId`, `rev`, `expectedRev`).
- Optimistic updates in the UI are acceptable if they are eventually consistent with the backend.
- If a UI-only state change is proposed for shared data, the AI must flag it as a violation.

---

## 6. Minimum Test Bar

Every proposed change must include at least one verification method:

| Type | When to Use |
|---|---|
| **Smoke test** | After starting a server, verify it responds |
| **curl verification** | After API changes, verify the response |
| **Unit test plan** | After logic changes, describe what should be tested |
| **Migration verify** | After DB changes, query to confirm schema |

Omitting all four is a Decision Gate failure. The AI must explicitly label which type is provided.

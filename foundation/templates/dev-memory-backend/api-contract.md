# Dev Memory — API Contract

> This document describes the REST endpoints conceptually.
> No framework-specific code is provided. Implement using your stack of choice.

---

## Philosophy

- **Write-first, append-only.** Dev Memory is a log, not a CRUD app.
- **PATCH is limited.** Only task metadata (title, description, status) may be updated. Historical entries are never mutated.
- **Interactions are immutable.** Once written, an interaction record is permanent.

---

## Endpoints

### `POST /dev-memory/tasks`

**Purpose:** Create a new development task.

**Input:**
| Field | Type | Required |
|---|---|---|
| title | string | ✅ |
| description | string | ❌ |
| context | object | ❌ |

**Output:** The created task object with `id`, `created_at`, and defaults applied.

---

### `GET /dev-memory/tasks`

**Purpose:** List all development tasks, ordered by most recent first.

**Input:** None (query params for pagination are implementation-specific).

**Output:** Array of task objects.

---

### `GET /dev-memory/tasks/:id`

**Purpose:** Retrieve a single task by ID.

**Input:** `id` as URL parameter.

**Output:** Full task object including `changes` and `context`.

---

### `PATCH /dev-memory/tasks/:id`

**Purpose:** Update mutable task fields only.

**Allowed fields:**
| Field | Type |
|---|---|
| title | string |
| description | string |
| status | string |
| changes | object[] (append) |
| context | object (merge) |

**Rule:** `changes` entries are appended, never replaced. `context` is shallow-merged.

**Output:** The updated task object.

---

### `POST /dev-memory/tasks/:id/interactions`

**Purpose:** Log an AI interaction against a task.

**Input:**
| Field | Type | Required |
|---|---|---|
| role | string | ✅ |
| content | string | ❌ |
| context | object | ❌ |

**Rule:** Interactions are **immutable**. Once created, they cannot be edited or deleted.

**Output:** The created interaction object.

---

### `GET /dev-memory/tasks/:id/interactions`

**Purpose:** List all interactions for a given task, ordered chronologically.

**Input:** `id` as URL parameter.

**Output:** Array of interaction objects.

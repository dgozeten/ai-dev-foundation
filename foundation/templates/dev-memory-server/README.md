# Dev Memory Server

Minimal, runnable backend for the Dev Memory API.

Single file. No ORM. No auth. No framework magic.
Just Fastify + PostgreSQL.

---

## Quick Start

```bash
# 1. Copy to your project (or use init.sh --with-server)
cp -r foundation/templates/dev-memory-server ./dev-memory-server

# 2. Install dependencies
cd dev-memory-server
npm install

# 3. Set your database URL
cp .env.example .env
# Edit .env with your PostgreSQL credentials

# 4. Run migrations (creates tables)
npm run migrate

# 5. Start the server
npm start
```

Server runs on `http://localhost:3100` by default.

---

## Endpoints

| Method | Path | Purpose |
|---|---|---|
| `POST` | `/dev-memory/tasks` | Create a development task |
| `GET` | `/dev-memory/tasks` | List all tasks |
| `GET` | `/dev-memory/tasks/:id` | Get a single task |
| `PATCH` | `/dev-memory/tasks/:id` | Update task metadata |
| `POST` | `/dev-memory/tasks/:id/interactions` | Log a prompt/response |
| `GET` | `/dev-memory/tasks/:id/interactions` | List interactions for a task |
| `GET` | `/invariants` | List all active invariants |
| `GET` | `/invariants/check` | Pre-mutation check (critical invariants only) |
| `GET` | `/health` | Health check |

---

## Migrations

The server reads SQL files from a `migrations/` directory (sorted alphabetically).
Only files starting with `0` and ending with `.sql` are executed.

When using `init.sh --with-server --with-db`, migration files are automatically
copied into the server's `migrations/` directory.

---

## Environment Variables

| Variable | Default | Required | Purpose |
|---|---|---|---|
| `DATABASE_URL` | — | ✅ | PostgreSQL connection string |
| `DEV_MEMORY_PORT` | `3100` | ❌ | Port to listen on |

---

## Integration with Antigravity

Set this in your project environment:

```bash
export DEV_MEMORY_URL=http://localhost:3100
```

Then `log-interaction.sh` and the Antigravity workflow will automatically
POST interactions to this server.

---

## What This Server Is NOT

- Not production infrastructure — it is a development tool
- Not auth-protected — add auth if you expose it beyond localhost
- Not horizontally scalable — single instance, single database
- Not an ORM — raw SQL, deliberate and transparent

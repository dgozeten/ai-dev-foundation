const Fastify = require("fastify");
const { Pool } = require("pg");
const { randomUUID } = require("crypto");
const fs = require("fs");
const path = require("path");

// =============================================================================
// Configuration
// =============================================================================

const PORT = parseInt(process.env.DEV_MEMORY_PORT || "3100", 10);
const DATABASE_URL = process.env.DATABASE_URL;

if (!DATABASE_URL) {
  console.error("ERROR: DATABASE_URL environment variable is required.");
  process.exit(1);
}

const pool = new Pool({ connectionString: DATABASE_URL });
const app = Fastify({ logger: true });

// =============================================================================
// Migration runner
// =============================================================================

async function migrate() {
  const migrationsDir = path.join(__dirname, "migrations");
  if (!fs.existsSync(migrationsDir)) {
    console.log("No migrations directory found. Skipping.");
    return;
  }

  const files = fs.readdirSync(migrationsDir)
    .filter(f => f.endsWith(".sql") && f.startsWith("0"))
    .sort();

  const client = await pool.connect();
  try {
    for (const file of files) {
      const sql = fs.readFileSync(path.join(migrationsDir, file), "utf8");
      console.log(`Running migration: ${file}`);
      await client.query(sql);
    }
    console.log("All migrations applied.");
  } finally {
    client.release();
  }
}

// =============================================================================
// Routes — Development Tasks
// =============================================================================

// POST /dev-memory/tasks — Create a new development task
app.post("/dev-memory/tasks", async (req, reply) => {
  const { title, description, context } = req.body || {};

  if (!title) {
    return reply.status(400).send({ ok: false, error: "title is required" });
  }

  const id = randomUUID();
  const now = new Date().toISOString();

  const result = await pool.query(
    `INSERT INTO development_tasks (id, title, description, context, created_at, updated_at)
     VALUES ($1, $2, $3, $4, $5, $5)
     RETURNING *`,
    [id, title, description || null, JSON.stringify(context || {}), now]
  );

  return reply.status(201).send({ ok: true, task: result.rows[0] });
});

// GET /dev-memory/tasks — List all tasks (most recent first)
app.get("/dev-memory/tasks", async (req, reply) => {
  const result = await pool.query(
    "SELECT * FROM development_tasks ORDER BY created_at DESC"
  );
  return { ok: true, tasks: result.rows };
});

// GET /dev-memory/tasks/:id — Get a single task
app.get("/dev-memory/tasks/:id", async (req, reply) => {
  const result = await pool.query(
    "SELECT * FROM development_tasks WHERE id = $1",
    [req.params.id]
  );

  if (result.rows.length === 0) {
    return reply.status(404).send({ ok: false, error: "task not found" });
  }

  return { ok: true, task: result.rows[0] };
});

// PATCH /dev-memory/tasks/:id — Update mutable task fields
app.patch("/dev-memory/tasks/:id", async (req, reply) => {
  const { title, description, status, changes, context } = req.body || {};
  const id = req.params.id;

  // Fetch current task
  const current = await pool.query(
    "SELECT * FROM development_tasks WHERE id = $1",
    [id]
  );

  if (current.rows.length === 0) {
    return reply.status(404).send({ ok: false, error: "task not found" });
  }

  const task = current.rows[0];

  // Merge changes (append) and context (shallow merge)
  const mergedChanges = changes
    ? [...(task.changes || []), ...changes]
    : task.changes;

  const mergedContext = context
    ? { ...(task.context || {}), ...context }
    : task.context;

  const result = await pool.query(
    `UPDATE development_tasks
     SET title = $1, description = $2, status = $3,
         changes = $4, context = $5, updated_at = $6
     WHERE id = $7
     RETURNING *`,
    [
      title || task.title,
      description !== undefined ? description : task.description,
      status || task.status,
      JSON.stringify(mergedChanges),
      JSON.stringify(mergedContext),
      new Date().toISOString(),
      id,
    ]
  );

  return { ok: true, task: result.rows[0] };
});

// =============================================================================
// Routes — AI Interactions
// =============================================================================

// POST /dev-memory/tasks/:id/interactions — Log an interaction
app.post("/dev-memory/tasks/:id/interactions", async (req, reply) => {
  const taskId = req.params.id;
  const { role, content, context } = req.body || {};

  if (!role) {
    return reply.status(400).send({ ok: false, error: "role is required" });
  }

  const id = randomUUID();
  const now = new Date().toISOString();

  const result = await pool.query(
    `INSERT INTO ai_interactions (id, task_id, role, content, context, created_at)
     VALUES ($1, $2, $3, $4, $5, $6)
     RETURNING *`,
    [id, taskId, role, content || null, JSON.stringify(context || {}), now]
  );

  return reply.status(201).send({ ok: true, interaction: result.rows[0] });
});

// GET /dev-memory/tasks/:id/interactions — List interactions for a task
app.get("/dev-memory/tasks/:id/interactions", async (req, reply) => {
  const result = await pool.query(
    "SELECT * FROM ai_interactions WHERE task_id = $1 ORDER BY created_at ASC",
    [req.params.id]
  );

  return { ok: true, interactions: result.rows };
});

// =============================================================================
// Routes — Foundation Invariants
// =============================================================================

// GET /invariants — List all active invariants
app.get("/invariants", async (req, reply) => {
  const result = await pool.query(
    "SELECT * FROM foundation_invariants WHERE active = true ORDER BY id ASC"
  );
  return { ok: true, invariants: result.rows };
});

// GET /invariants/check — Pre-mutation check (returns all critical invariants AI must respect)
app.get("/invariants/check", async (req, reply) => {
  const result = await pool.query(
    "SELECT id, title, description, category FROM foundation_invariants WHERE active = true AND severity = 'critical' ORDER BY id ASC"
  );
  return {
    ok: true,
    count: result.rows.length,
    invariants: result.rows,
    message: result.rows.length > 0
      ? "You MUST respect ALL listed invariants before proceeding with any mutation."
      : "No active invariants."
  };
});

// =============================================================================
// Health check
// =============================================================================

app.get("/health", async (req, reply) => {
  try {
    await pool.query("SELECT 1");
    return { ok: true, status: "healthy" };
  } catch (err) {
    return reply.status(503).send({ ok: false, status: "unhealthy", error: err.message });
  }
});

// =============================================================================
// Start
// =============================================================================

async function start() {
  try {
    // Verify DB connection
    await pool.query("SELECT 1");
    console.log("Database connection verified.");

    await app.listen({ port: PORT, host: "0.0.0.0" });
    console.log(`Dev Memory API running on http://localhost:${PORT}`);
  } catch (err) {
    console.error("Failed to start server:", err.message);
    process.exit(1);
  }
}

// Export migrate for CLI usage
module.exports = { migrate };

// If run directly, start the server
if (require.main === module) {
  start();
}

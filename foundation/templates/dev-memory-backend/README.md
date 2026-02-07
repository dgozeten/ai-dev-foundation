# Dev Memory — Backend Foundation Template

## What Is Dev Memory?

Dev Memory is a **development-time traceability system** that records:

- What development tasks were performed
- What changes were made and why
- What AI interactions influenced those changes
- The reasoning and context behind decisions

It provides a persistent, queryable history of the development process itself.

## What Problems Does It Solve?

| Problem | How Dev Memory Addresses It |
|---|---|
| "Why was this code written this way?" | Every task records its rationale and context |
| "What did the AI suggest vs. what we actually did?" | AI interactions are logged with inputs and outputs |
| "What changed in this session?" | Tasks track change summaries as structured JSONB |
| "We lost context after a chat reset" | Memory lives in the database, not in chat history |

## What Dev Memory Is NOT

- ❌ **Not a production audit log.** This is for development insight, not compliance.
- ❌ **Not an application feature.** End users never see or interact with this.
- ❌ **Not a replacement for git history.** Git tracks *what* changed; Dev Memory tracks *why*.
- ❌ **Not mandatory.** It is opt-in per project.

## Usage

1. Run `migration.sql` against your development database
2. Wire up the endpoints described in `api-contract.md`
3. See `integration-notes.md` for guidance on plugging this into your project

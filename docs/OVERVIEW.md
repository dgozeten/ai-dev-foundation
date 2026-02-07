# Overview — The Mental Model Behind ai-dev-foundation

This document explains **why** this foundation exists, not how to set it up.

If you want setup instructions, read [README.md](../README.md).
If you want the rules themselves, read [RULES.md](../foundation/rules/.gemini/RULES.md).

---

## The Core Problem

AI coding assistants are **stateless operators**. Every session starts from zero. They have no memory of previous decisions, no awareness of past mistakes, and no obligation to follow rules that were established in a prior conversation.

This creates a fundamental reliability problem:

- Rules declared in chat evaporate when the session ends.
- Decisions made on Tuesday are forgotten by Wednesday.
- AI rewrites code it wrote yesterday, because it has no record of why it wrote it.
- Two people working with the same AI get inconsistent behavior, because each session has its own invisible context.

Conversation memory is not a solution. It is volatile, unversioned, unshareable, and non-auditable. Anything that relies on conversation memory is, by definition, unreliable.

## Why .md Rules Alone Are Not Enough

Putting rules in a markdown file is a start. But rules without enforcement mechanisms are suggestions, not constraints.

A rule that says "always ask before writing code" is effective only if:
1. The AI actually reads the file at session start
2. The rule is specific enough to be unambiguous
3. There is a verifiable structure (the Decision Gate) that makes compliance visible
4. There is a persistent record of whether the gate was followed

Rules must be paired with **structure** and **persistence**. A rule without a record is a wish. A rule with a record is a contract.

## Why Decisions Must Be Persisted

When an AI helps build software, the process generates decisions:
- Why was this approach chosen over alternatives?
- What risks were identified?
- What was approved and by whom?

If these decisions exist only in a chat window, they are gone the moment the window closes. The next person — or the next AI instance — has no idea why things are the way they are.

**Dev Memory** solves this. It is a simple, database-backed log of development tasks and AI interactions. It is not an audit system for compliance. It is a development tool for sanity — so that "why?" always has an answer.

## Why AI Is an Operator, Not an Agent

There is a temptation to treat AI as an autonomous agent: give it a goal and let it figure out the rest.

This foundation rejects that model.

AI is an **operator** — a highly capable tool that executes within explicit boundaries set by a human. It does not set its own goals. It does not decide its own scope. It does not approve its own plans.

The Decision Gate enforces this:

```
Human → Request → Decision Gate → Approval → Mutation → Record
```

Every step requires the human to remain in control. The AI proposes; the human disposes.

## Why Fire-and-Forget Logging Is Critical

Dev Memory logging must never block the actual work. If a log write fails, the mutation still succeeds. If Dev Memory is down, the application continues.

This is not a compromise — it is a design principle.

Development tooling must be **invisible when it works and absent when it fails**. The moment a development aid blocks production behavior, it has become a liability, not an asset.

The same applies to State Protocol logging: mutation success is sacred. Logging is best-effort. A failed log entry is acceptable. A blocked mutation is not.

## The Flow

```
1. Human makes a request
2. AI produces a Decision Gate analysis
3. Human approves, rejects, or modifies
4. AI executes the approved mutation
5. State Protocol ensures the mutation is safe (idempotent, conflict-aware)
6. Dev Memory records what happened and why (fire-and-forget)
7. The record survives the session
```

Every step is explicit. Nothing is assumed. Nothing is silent.

---

## Summary

This foundation exists because AI-assisted development is powerful but unreliable without structure. The structure is simple:

- **Rules** govern what the AI may do.
- **Decision Gate** ensures it asks before acting.
- **State Protocol** ensures mutations are safe.
- **Dev Memory** ensures decisions are remembered.

None of these are optional suggestions. Together, they form a minimum viable discipline for working with AI on projects that matter.

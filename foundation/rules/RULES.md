# Persistent AI Rules

This project enforces **Persistent AI Rules** that govern all AI behavior.

---

## Source of Truth

The authoritative rule definition lives at:

```
foundation/rules/.gemini/RULES.md
```

That file is the ONLY valid source for AI behavior rules.
This file is a pointer — not a replacement.

---

## For Contributors

> [!CAUTION]
> **Do NOT bypass, override, or duplicate the rules defined in `.gemini/RULES.md`.**
>
> - Do not place conflicting rules in chat instructions.
> - Do not create alternative rule files that contradict the source of truth.
> - Do not assume rules from previous conversations carry over — only repository rules are valid.
>
> If you need to change AI behavior, submit a change to `.gemini/RULES.md` and get it reviewed.

---
name: agent-run-eval
description: Treat agent runs as evals — after a notable agent run, log the input, the expected output, the actual output, a pass/fail verdict, and one improvement note. Builds a durable record that answers "did the input produce what I expected, and how do I make it better next time?". Use for orchestrated agent runs, cron agents, and any generation you'll rely on repeatedly.
---

# Agent-Run Eval — "did I get what I expected?"

Most teams test their *product* (unit tests, smoke tests, deploy validation). Far fewer test their *agents*. This skill adds the missing loop: every notable agent run leaves an eval record, so quality is measured and improvable instead of vibes-based.

## When to use

- After an **orchestrated agent run** produces something you'll act on (requirements, stories, research, code changes).
- After a **scheduled/cron agent** fires (audits, health checks, scrapers) — did it do its job?
- When you're **iterating on a prompt or skill** and want to know if a change actually helped.

Skip it for trivial one-off chatter.

## The eval record

Append one JSON line per run to `agent-evals.jsonl` in the workspace:

```json
{"ts":"2026-07-24T18:50:00Z","agent":"requirements-synthesizer","run_id":"r-014-v3",
 "input":"transcript.txt 00:00-01:50 + stakeholder email",
 "expected":"3-6 requirements, each grounded in a source quote, SSO covered",
 "actual":"5 requirements, all sourced, SSO covered, one marked [inferred]",
 "verdict":"pass",
 "score":4,
 "improve":"story-writer over-narrowed REQ-014; add 'prefer broader scope unless told otherwise' to its prompt"}
```

Fields:
- **expected** — write this *before or independent of* looking at `actual`, or the eval is just rationalization.
- **verdict** — `pass` | `partial` | `fail`.
- **score** — optional 1–5, for tracking trend over time.
- **improve** — the single most valuable change for next time. This is the payload; a record with no `improve` note is half-useful.

## The loop

```
run agent  →  compare actual vs expected  →  verdict + score  →  improve note
     ▲                                                              │
     └──────────────  fold improve note into prompt/skill  ─────────┘
```

1. **Define expected up front.** Even a rough sketch ("a backlog of 4–8 stories, no duplicates, each with acceptance criteria") makes the run measurable.
2. **Log actual honestly.** If it failed, say so with the specifics — a `fail` record is more valuable than a vague `pass`.
3. **Turn `improve` into a change.** Edit the agent's prompt/skill, then re-run and log again. Watch `score` move.
4. **Review the log periodically.** Grep for `"verdict":"fail"` to find your weakest agents; that's your work list.

## Tie-ins

- Pairs with [[provenance]]: the eval's `run_id` should match the artifact's `Artifact ID + Version`, so a failing eval points straight at the artifact and its sources.
- In a scheduled/cron setup, have each job append its own eval line; a weekly agent can then summarize pass rates and surface regressions.
- This is the agentic-flow analogue of a test suite. Your product tests answer "does the app work?"; these answer "do my agents work?"

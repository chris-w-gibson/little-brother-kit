# Career Journal — your work becomes your resume

Turns the work you do with your companion into durable career capital: a running record of
accomplishments, and on demand, resume bullets and a portfolio narrative.

**This is the "your work is your resume" pillar.** As you use the companion to get things done,
it quietly captures *what you accomplished* — so that when you need a resume, a review write-up,
or to remember what you actually shipped last quarter, it's already there.

## Privacy boundary (read first — this is different from telemetry)

The career journal contains **real work content** — accomplishments, projects, outcomes. That
makes it categorically different from telemetry, so it has its own rules:

- It lives **only** on the user's machine, at `~/.companion/career/journal.md`.
- It is **NEVER synced** to the maintainer. Not in the telemetry stream, not anywhere. The
  metadata telemetry system (the `telemetry` skill) and this are separate; this one stays home.
- It is the user's asset, fully. They own it, edit it, export it, delete it.
- Exports (a resume, a portfolio doc) are produced locally and go wherever the user sends them.

If you are ever unsure whether something belongs in telemetry or the career journal: work
*content* → career journal (local, private). Usage *metadata* → telemetry (if consented).

## What to capture

At the end of a meaningful task, append a short accomplishment entry. Capture outcome and
impact, not keystrokes:

```
## 2026-07-27 — [industry/role context]
- Accomplishment: <what got done, in the user's own domain terms>
- Impact: <who it helped / time saved / what it unblocked>
- Skills shown: <the transferable capability — "process automation", "data analysis", "client comms">
- Artifacts: <local pointers only — never copy sensitive content in>
```

Prompt lightly, don't nag. One good entry per real accomplishment beats a log of everything.

## On request — generate career artifacts

- **Resume bullets**: turn journal entries into strong, quantified resume lines
  ("Automated the monthly close reconciliation, cutting a 2-day task to 3 hours").
  Lead with impact and numbers. Use the user's real industry language.
- **Portfolio narrative**: a short prose summary of what they've built/done over a period.
- **Review / brag doc**: for a performance review — accomplishments grouped by theme.

Always show a draft and let the user edit. Their voice, their claims — never inflate.

## Why this matters for non-developers

The target user isn't a developer; they're someone condensing knowledge work whose *work is
their professional reputation*. Most people do good work and then can't remember or articulate
it later. The companion that both helps you do the work AND hands you the evidence of it is
worth paying for in a way a generic assistant isn't.

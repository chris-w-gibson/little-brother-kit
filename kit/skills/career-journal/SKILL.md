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

## Entry format (append to ~/.companion/career/journal.md)

Newest at the bottom. Keep each entry tight — outcome and impact, not a play-by-play:

```
## 2026-07-27 — <short title of what got done>
- Did: <what you accomplished, in the user's own domain terms>
- Impact: <who it helped / time saved / what it unblocked — a number if there is one>
- Shows: <the transferable skill — "process automation", "client communication", "data analysis">
```

Prompt lightly, never nag. One real accomplishment beats a log of everything.

## On request — generate career artifacts

- **Resume bullets**: turn entries into strong lines — start with a past-tense action verb,
  lead with impact, quantify wherever the journal supports it, use the user's industry language.
  Good: "Automated the monthly close reconciliation, cutting a 2-day task to 3 hours."
  Weak: "Responsible for reconciliation." Never invent numbers the journal doesn't support.
- **Portfolio narrative**: a short prose summary of what they've built/done over a period.
- **Review / brag doc**: for a performance review — accomplishments grouped by theme.

Always show a draft and let the user edit. Their voice, their claims — never inflate.

## Why this matters for non-developers

The target user isn't a developer; they're someone condensing knowledge work whose *work is
their professional reputation*. Most people do good work and then can't remember or articulate
it later. The companion that both helps you do the work AND hands you the evidence of it is
worth paying for in a way a generic assistant isn't.

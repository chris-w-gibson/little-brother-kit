# Operating Rules — Little Brother (starter template)

A portable methodology for working with an AI coding companion (Claude Code or similar).
Drop this in your home config (e.g. `~/.claude/CLAUDE.md`) and adapt. Everything here is
generic — fill the bracketed placeholders with your own projects and conventions.

---

## Collaboration Contract — signal prefixes

Use these consistently; the agent acts based on the prefix.

| Prefix | Meaning | Agent response |
|---|---|---|
| **`NEED:`** | Blocking on your input | Answer before continuing |
| **`CONFIRM:`** | Proposed action with real consequences | Approve or redirect |
| **`WAIT:`** | Timed pause (deploy, migration) | Just wait |
| **`FYI:`** | Informational | Read; flag if wrong |
| **`BLOCKED:`** | Hit an obstacle, surfacing it | Decide: unblock, pivot, or drop |

If no prefix is used, the agent is actively working.

---

## Development Lifecycle (drive every code change through this)

```
IMPLEMENT -> TEST -> LINT -> TYPECHECK -> COMMIT -> PUSH -> VALIDATE
```

1. After implementing, run tests without being asked.
2. Tests pass -> lint -> typecheck. Fix and re-run on any failure; don't skip.
3. Ask before commit/push: `CONFIRM: all gates passed. Commit and push?`
4. After push: validate the change in the real running app, not just the header/build.

**Never without explicit approval:** push to main, force-push, commit without being told,
`git reset --hard`, branch deletion, `--no-verify`, uploading code/data to third-party tools.

---

## Memory Discipline — three layers

| Goes in | What |
|---|---|
| **Git log** | What changed, when, with what commit |
| **Project CLAUDE.md** | Stable project facts — accounts, architecture, conventions |
| **Agent memory** | Your preferences, feedback rules, cross-session context |
| **Task list / plan** | Ephemeral in-session progress |

Don't put in-progress work or "next up" TODOs into long-term memory — those belong in git or a plan file.

---

## The Harness (agentic flow)

This kit ships three skills that add the traceability + feedback loop most agentic setups miss.
See each skill's `SKILL.md` and the README. In short:

- **clarity-harness** — orchestrator -> interview / requirements / story-writer, with a
  human-as-judge approve/annotate/regenerate loop.
- **provenance** — every artifact carries its lineage: source quotes, agent chain, diff-from-previous.
- **agent-run-eval** — every notable agent run logs input / expected / actual / verdict / improve.
- **career-journal** — captures accomplishments as work happens; generates resume bullets /
  portfolio on demand. **Local, user-owned, never synced.** "Your work is your resume."
- **telemetry** — local usage journal + consent-gated metadata sync. Off unless the user
  consented during onboarding. Respect its hard rules (metadata only; "off" is instant and final).

_Note: the Development Lifecycle above is for technical work. For non-developer users, "drive it
to done and verify it actually worked" is the spirit — skip the test/lint/typecheck specifics._

Layer your harnesses: **individual** (personal rules + skills) under **domain** (per-discipline)
under **team/company** (org-wide). The more specific one wins.

## Working in the user's environments (read/write, safely)

An "environment" is a place they work — a folder of files, or a web tool like ServiceNow.
- **Read the environment's context first** — a `little-brother.md` or `CLAUDE.md` in that
  folder (template at ~/.companion/templates/environment-context.md). It says what the space
  is and what you may do there.
- **Read-only is the default.** Look and help; change nothing unless the environment's context
  explicitly grants read-and-write.
- **Confirm every write.** Show exactly what you'll change and wait for a yes; screenshot +
  confirm before anything irreversible.
- **Never touch work systems the user hasn't allowed.** Enterprise/security environments are
  assist-only unless the user confirms their employer permits more (see workflow-integration).

Read `~/.claude/FIRST-WINS.md` when the user is unsure what to ask for — offer them 2–3 concrete, tailored quick wins rather than an open-ended question.

Read `~/.claude/LEARNINGS.md` for cross-companion lessons — generalized patterns and common
walls other users hit. It grows with each `companion update`.

---

## Project Registry (fill in your own)

| Project | Path | Stack | Deploy | DB |
|---|---|---|---|---|
| [Project A] | [~/path] | [stack] | [target] | [db] |

_Adapt this file to your setup. Delete this template comment when you do._

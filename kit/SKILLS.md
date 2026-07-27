# Bundled skills

The starter pack is deliberately small and **role-agnostic** — a methodology core that
helps anyone doing knowledge work, not a pile of tools most people won't touch. Role-specific
skills get added per pilot (see "Tuning" below) and, over time, from what telemetry shows
people actually reach for.

## The core pack (ships with every companion)

| Skill | What it does | Why it's in the default |
|---|---|---|
| **clarity-harness** | Turns raw input (a meeting, a brief, a rambling idea) into an approved, traceable set of requirements/stories via a human-as-judge loop. | The single highest-leverage move for knowledge work — most people's ideas die in the gap between "thought" and "plan". |
| **provenance** | Stamps every generated artifact with its lineage: source quotes, the agent chain that made it, the diff from last version. | Trust. You can always answer "what got me here?" — essential once an agent is producing durable work. |
| **agent-run-eval** | Logs notable agent runs as evals: input / expected / actual / verdict / one improvement. | Makes the companion improve deliberately instead of drifting. Also the honest raw material behind telemetry. |
| **career-journal** | Captures accomplishments as you work; generates resume bullets / portfolio / review write-ups on demand. **Local, user-owned, never synced.** | The differentiator — "your work is your resume." The reason a non-dev pays for this over a generic assistant. |
| **telemetry** | Local usage journal + consent-gated metadata sync. | The flywheel. Off by default; see README. |

## Tuning per pilot (maintainer)

Before onboarding a pilot, add skills matching what they actually do. Curation rules:

- **Include** general-purpose skills that fit their work (e.g. a debugging methodology for
  engineers, a document/requirements skill for PMs, a browser-automation skill for ops).
- **Exclude** anything project-scoped or personal to the maintainer — validation skills tied
  to specific apps, deploy skills for specific infra, anything with a hardcoded path or account.
- **Never** ship a skill that carries a credential or a private endpoint. The packaging
  secret-scan (below) is the backstop, not the plan.

Add a skill by dropping its `skills/<name>/SKILL.md` folder into the kit before the pilot clones,
or ship it later via `companion update`.

## Packaging safety gate (maintainer, mandatory)

Run before every kit change is committed or a pilot pulls:

```bash
grep -rIEn 'sbp_[A-Za-z0-9]{20,}|sk-ant-[A-Za-z0-9_-]{20,}|ghp_[A-Za-z0-9]{30,}|AKIA[0-9A-Z]{16}|-----BEGIN [A-Z ]*PRIVATE KEY|eyJ[A-Za-z0-9_-]{30,}\.[A-Za-z0-9_-]{20,}|AIza[0-9A-Za-z_-]{35}' kit/
```

Zero matches required. This exists because real credentials have been found inside skills
before — a scan is mechanical; vigilance isn't.

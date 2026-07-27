# Telemetry — usage journal + consented sync

**Consent version: 2026-07-27.2** (adds industry/role to what's recorded)

Journals companion usage locally and — only after explicit consent — syncs event
*metadata* to the kit maintainer's backend so they can see where users succeed, get
stuck, and what skills to build next.

## Hard rules (these override everything else in this file)

1. If `~/.companion/config.json` has `telemetry.enabled != true` or
   `telemetry.consented != true`: journal locally if useful, **never sync, never
   nag about enabling**.
2. Sync **metadata only**. An event NEVER contains: prompt text, code, file
   contents, file names, directory names, repo names, URLs, error message bodies,
   or anything typed by the user. If unsure whether a field is metadata, it isn't.
3. The user saying anything like "turn telemetry off" → set `telemetry.enabled=false`
   immediately, confirm in one line, done. No confirmation dialog, no "are you sure".
4. The journal at `~/.companion/journal.jsonl` is the user's file. Show it whenever
   asked ("show my journal").

## Event schema (one JSON line per event, append-only)

```json
{"ts":"2026-07-27T14:02:11Z","event":"skill_run","skill":"clarity-harness","outcome":"success","duration_s":340,"error_category":null}
```

- `event`: `skill_run` | `task` | `wall` | `session_start` | `session_end`
- `outcome`: `success` | `failure` | `abandoned`
- `error_category`: null or a coarse bucket — `auth`, `env-setup`, `tool-missing`,
  `model-limitation`, `user-blocked`, `other`. Never the actual error text.

## The `wall` event (most important signal)

Emit when the user is genuinely stuck: 3+ consecutive failures at the same task, an
abandoned multi-step task, or the user saying "I give up / I'm stuck / this isn't working".
Add `wall_category`: what *kind* of capability was missing (e.g. `browser-automation`,
`data-transform`, `deploy`, `unknown`) — category only, no specifics.

## When to journal

At natural boundaries — after a skill finishes, a task resolves or is abandoned, a wall
is hit, session start/end. Append with a single shell echo; do not batch in memory.

## Sync

If and only if consented+enabled: run `~/.companion/telemetry-sync.sh` at session end
(it POSTs unsent journal lines with the user's sync key, marks a high-water line
number in config, and is safe to re-run). Failures are silent — never block or bother
the user because telemetry couldn't sync.

## CONSENT section (present verbatim during onboarding)

> **What syncs**: your industry and role (so the maintainer knows which fields are
> represented and where to improve), plus event metadata only — which skill/tool ran,
> success/failure/wall, a coarse error category, duration, timestamp.
> **What never syncs**: your prompts, your actual work, file contents, file/repo names,
> URLs, error text, and your career journal — nothing you typed and nothing from your
> machine's contents.
> **Where it goes**: the kit maintainer's private database, used to decide which
> skills to build and to find where users get stuck.
> **Your controls**: the full journal is a local file you can read anytime
> ("show my journal"); "turn telemetry off" disables it instantly and permanently
> unless you re-enable it yourself.

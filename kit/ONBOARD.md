# Onboarding — paste everything below into Claude Code after running install.sh

---

You are my new work companion. The kit at ~/.claude (operating rules + skills) was just
installed. Run my onboarding now, in four steps. Be conversational but efficient — this
should take about ten minutes.

STEP 1 — Persona interview
Interview me one topic at a time (don't dump all questions at once). I may not be a
developer — keep it plain, no jargon:
- What I do: my industry/field, my role or job title, what a good week looks like.
  (Industry matters — capture it clearly; it's part of my profile.)
- My work: the recurring tasks that eat my time, the stuff I'd love to condense.
- My tools: what I use daily (email, spreadsheets, whatever — not just code).
- How I like to work: cautious vs fast, how much I want explained, pet peeves.
- What I most want help with right now.

STEP 2 — Write my context
Using my answers:
- Fill every bracketed placeholder in ~/.claude/CLAUDE.md (project registry, conventions).
  If a CLAUDE.companion.md exists instead, merge it with my pre-existing CLAUDE.md —
  show me the merged result before writing.
- Create a memory file recording who I am and how I like to work, so future sessions
  start warm.
Show me what you wrote. Revise until I approve.

STEP 3 — Telemetry choice (read this to me straight, no selling)
Read ~/.claude/skills/telemetry/SKILL.md, then present its CONSENT section verbatim.
The short version you must convey:
- What syncs: my industry and role (so the maintainer knows which fields are represented),
  plus event metadata only — which skill/tool ran, success/failure/wall, an error category,
  duration, timestamp. NEVER my prompts, my actual work, file contents, file names, or the
  contents of my career journal.
- Where it goes: the kit maintainer's private database, to figure out which new
  skills to build and where people get stuck.
- My controls: the journal is a local file I can read anytime; one command turns
  telemetry off; off means off.
Then ask me plainly: enable it, or leave it off?
- If I consent: set telemetry.enabled=true, telemetry.consented=true, and
  consent_version from the SKILL.md in ~/.companion/config.json, and ask the kit
  maintainer for my sync key.
- If I decline: leave it off, never raise it again unless I do.

STEP 4 — First win + career journal
Ask what I'm working on today and help me with one real task, however small.
When it's done, use the career-journal skill to log that accomplishment (locally — this is
mine, it never syncs anywhere) so it starts building my resume/work record from day one.
End by telling me the three most useful things I can ask you for, based on my interview —
and that I can ask you for "resume bullets" or "what did I get done this month" anytime.

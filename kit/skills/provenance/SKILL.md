---
name: provenance
description: Stamp every generated artifact with an inspectable lineage — source quotes, the agent/skill chain that produced it, and the diff from the previous version. Use whenever an agent produces or regenerates a durable artifact (requirement, story, spec, report, decision) and you want to be able to answer "what got me here?". Closes the traceability gap in agentic workflows.
---

# Provenance — "what got me here?"

Every artifact an agent produces should carry its own lineage so a human judge can trust it: where each claim came from, which agents touched it, and what changed since last time. This is the single highest-leverage addition to an agentic workflow — it turns opaque generations into reviewable ones.

## When to use

Invoke (or follow) this skill whenever an agent writes or **regenerates** a durable artifact:
- a requirement, user story, spec, or acceptance criteria
- a research report or summary grounded in sources
- a design decision or ADR
- anything a human will approve, ship, or be accountable for

Do **not** bother for throwaway scratch output.

## The lineage block

Append this block to the bottom of every artifact (or store it alongside as `<artifact>.prov.json`). Markdown form:

```markdown
---
## Provenance
- **Artifact ID:** REQ-2026-014            <!-- stable across regenerations -->
- **Version:** 3                            <!-- bump on each regenerate -->
- **Produced by:** clarity-orchestrator → requirements-synthesizer → story-writer
- **Skills used:** meeting-requirements, provenance
- **Sources:**
  - `transcript.txt:00:04:12` — "we should think about a way to scale this as a service"
  - `stakeholder-email-2026-07-19.md:L14` — "must support SSO by Q4"
- **Diff from v2:** broadened scope from "single-tenant" to "multi-tenant"; added SSO acceptance criterion.
- **Judge:** _pending_ | approved by <name> <date> | changes requested
```

JSON form (`REQ-2026-014.prov.json`) when you want it machine-readable:

```json
{
  "artifact_id": "REQ-2026-014",
  "version": 3,
  "chain": ["clarity-orchestrator", "requirements-synthesizer", "story-writer"],
  "skills": ["meeting-requirements", "provenance"],
  "sources": [
    {"ref": "transcript.txt", "loc": "00:04:12", "quote": "scale this as a service"},
    {"ref": "stakeholder-email-2026-07-19.md", "loc": "L14", "quote": "must support SSO by Q4"}
  ],
  "diff_from_prev": "broadened single-tenant → multi-tenant; added SSO criterion",
  "judge": {"status": "pending"}
}
```

## Rules

1. **Every claim traces to a source.** If a line in the artifact isn't grounded in a real source ref, mark it `[inferred]` so the judge knows it's the agent's own reasoning, not something from the input.
2. **The Artifact ID is stable; the Version bumps.** Regenerations keep the same ID so history is one chain, not N orphans.
3. **Always record the diff from the previous version.** "What changed and why" is what a reviewer reads first. See [[agent-run-eval]] to also score whether the change was an improvement.
4. **Never invent a source or a quote.** A fabricated citation is worse than no citation. Quote verbatim from the actual input; if you're paraphrasing, say so.
5. **Store lineage next to the artifact**, in the repo/workspace — not in ephemeral chat. It must survive the session.

## Minimal helper

Record lineage without hand-writing JSON:

```bash
# usage: prov-stamp <artifact_id> <version> <artifact_file> <chain> <note>
prov-stamp() {
  cat > "${3}.prov.json" <<EOF
{"artifact_id":"$1","version":$2,"chain":"$4","diff_from_prev":"$5","judge":{"status":"pending"}}
EOF
  echo "stamped $1 v$2 -> ${3}.prov.json"
}
```

Pair this with [[clarity-harness]] (which produces the artifacts) and [[agent-run-eval]] (which scores whether each run hit its target).

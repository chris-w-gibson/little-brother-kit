---
name: clarity-harness
description: Orchestrated PM/knowledge-work pipeline — capture input (interview), synthesize requirements, write user stories, with a human-as-judge approve/annotate/regenerate loop and full provenance on every artifact. Use to turn a meeting, transcript, or brief into a reviewable, traceable backlog. The connective tissue over the provenance and agent-run-eval skills.
---

# Clarity Harness

An orchestrator that turns raw input (a transcript, a brief, a stakeholder thread) into an approved, traceable backlog — while keeping a human in the loop as the judge. It's a *layered* harness: the same shape works for one person, a domain, or a whole team; you just swap which agents and sources are wired in.

## The shape

```
                       +-------------------------+
                       |  clarity-orchestrator   |
                       +-----------+-------------+
              +--------------------+--------------------+
              v                    v                     v
      interview-agent     requirements-synth       story-writer
     (capture input)   (source -> requirements)  (requirements -> stories)
              |                    |                     |
              +-------- every artifact carries ----------+
                        provenance + an eval record
                                   |
                                   v
                        human-as-judge: approve / annotate
                                   |
                        annotation saved -> regenerate (v+1)
```

## Roles

- **clarity-orchestrator** — owns the run. Decides which agents fire, in what order, and assembles the final artifact set. Calls agents, agents call skills.
- **interview-agent** — captures raw input into a durable, timestamped source (e.g. a transcript). Never edits meaning; just records. This is the source-of-truth other agents cite.
- **requirements-synthesizer** — reads sources -> emits requirements, each grounded in a source quote (see [[provenance]]). Marks anything not in the source as `[inferred]`.
- **story-writer** — turns approved requirements into user stories with acceptance criteria, carrying the same lineage forward.

## Run it

1. **Capture (interview-agent).** Get input into a durable artifact. If it's a recording, transcribe it first. Any local transcriber works (e.g. `faster-whisper`); write a timestamped `transcript.txt`. This file is committed source-of-truth — never delete or rewrite it.
2. **Synthesize (requirements-synthesizer).** Produce `requirements.md`: a numbered list, each item with an **Artifact ID**, the requirement text, and a **source quote** it traces to. Stamp provenance.
3. **Judge.** Present each requirement to the human with its provenance: *this came from this quote; this is the diff from last version.* The human does one of:
   - **approve** -> mark `judge: approved` in the lineage.
   - **annotate** -> e.g. "too narrow, broaden to multi-tenant." Save the note (next section).
4. **Regenerate.** For any annotated artifact, re-run its agent **with the annotation prepended to the prompt**, bump the version, and record the diff. Repeat until approved.
5. **Write stories (story-writer).** From approved requirements only, emit `stories.md` with acceptance criteria, lineage carried forward.
6. **Eval the run.** Log an [[agent-run-eval]] line for each agent: did the output match expectation, what to improve.

## Annotate -> regenerate (the core loop)

This is what most agentic setups are missing: feedback that is **artifact-scoped and re-applied**, not just global guidance.

Store annotations next to the artifact so a regeneration can fold them in:

```json
// REQ-014.annotations.json
{"artifact_id":"REQ-014","notes":[
  {"v":2,"note":"too narrow - broaden single-tenant to multi-tenant","by":"user","ts":"2026-07-24T18:40Z"}
]}
```

On regenerate, the agent's prompt becomes:
`<original synthesis prompt>` + `Prior version was rejected. Apply this correction: "too narrow - broaden single-tenant to multi-tenant". Regenerate REQ-014 as v3 and note the diff.`

The corrected artifact keeps the same **Artifact ID**, bumps to **v3**, and its provenance records the diff. History is one auditable chain.

## Layering

- **Individual harness** — your personal agents + skills + rules.
- **Domain harness** — shared agents for a discipline (PM, design, eng), e.g. a house style for stories.
- **Team/company harness** — org-wide agents, sources, and approval policy.
  Wire the more specific harness on top of the general one; the orchestrator resolves which applies.

## Non-negotiables

1. **Source-of-truth artifacts are immutable** (transcripts, captured input). Derived artifacts (requirements, stories) are regenerable and versioned.
2. **Every derived claim is traceable** to a source or marked `[inferred]` — [[provenance]].
3. **Nothing ships without a judge decision.** Approve or annotate; never silently accept.
4. **Every run leaves an eval record** — [[agent-run-eval]].
5. **Never fabricate a source quote** to make an artifact look grounded.

# Stage Manager — Artful Making Skill Library

A collection of 11 skills for vibe coders who use agentic coding tools (Claude Code, Cursor, Replit). Skills are organized across the Shape-to-Stage flow cycle. The mirror never goes dark.

## Available Slash Commands

### Shape (analyze before building)
- `/sm:shape:find-holes` — Find specification gaps where coding tools will invent behavior
- `/sm:shape:collapsed-options` — Find decisions made before the builder knew they were making them
- `/sm:shape:risk-sequence` — Surface load-bearing assumptions and sequence by cost-if-wrong
- `/sm:shape:soul-check` — Deep read on whether the original animating idea is still alive
- `/sm:shape:brief` — Synthesize shape skill output into ranked top-three problems, inline change suggestions, `Stage_Manager_Brief.md`, and `[Spec_Name]-Staged.md` — the handoff to CE or Superpowers

### Transition
- `/sm:shape:gate` — Five readiness questions before crossing from shaping to staging

### Stage (before, during, and after the build)
- `/sm:stage:chunking` — Break work into flow-cycle-sized pieces sequenced by cost of delay (economic, risk, flow, joy)
- `/sm:stage:prompt-craft` — Turn shaped chunks into scoped, guardrailed prompts
- `/sm:stage:live-mirror` — Compare plan vs. code output per-session, surface what the tool invented
- `/sm:stage:decision-capture` — Full decisions-made manifest after a build, feeds forward into learning

### Any Node
- `/sm:coherence-check` — Lightweight 2-minute gate at any transition point mid-build. For the shape/stage boundary, use `/sm:shape:brief` instead.

## The Shape Brief Flow

Run any shape skills, then run `/sm:shape:brief` to synthesize. It will:

1. Rank the top three problem areas across all skill output (scored by frequency + severity + proximity to core intent)
2. Present inline change suggestions — you accept, reject, or modify each one
3. Generate `Stage_Manager_Brief.md` — the handoff document
4. Write `[Spec_Name]-Staged.md` — the original spec with accepted changes applied

Then choose your handoff path:
- **Brief only** — paste `Stage_Manager_Brief.md` into CE or Superpowers
- **Brief + original spec** — when the full source context matters
- **Brief + Staged spec** — when you walked through fixes and want the next tool building from the resolved version

## Compound Engineering Integration

Modified CE commands that integrate Stage Manager at every phase live in `plugins/compound-engineering/commands/ce/`. Stage Manager gates are woven into brainstorm, plan, work, review, and compound — with Shape Brief as the canonical pre-planning handoff.

## Superpowers Integration

Stage Manager shapes your spec before Superpowers executes it. Run shape skills, run `/sm:shape:brief`, then hand the two output documents to Superpowers as the starting context. Superpowers handles all planning and execution interaction from there.

## Shared References

Reference files used by skills live in `plugins/shared/references/`:
- `invention-zones.md` — 12 architectural zones where coding tools invent without asking
- `tool-selection-zones.md` — Tool choices, alternatives, lock-in risks
- `breakthrough-dimensions.md` — Dimensions builders push on and where options collapse

## Soul Document

`stage-manager-soul.md` contains the animating philosophy: *How you move through your work is what you build.*

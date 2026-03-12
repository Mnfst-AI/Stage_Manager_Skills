# Stage Manager — Artful Making Skill Library

> **How you move through your work is what you build.**

A free, open collection of 10 skills for vibe coders who want to stay the author while building with AI tools.

These skills help you expand options before converging, maintain coherence across a build, and keep the soul of the work intact while Claude Code, Cursor, Replit, or any agentic coding tool runs at speed.

---

## What These Skills Are

Each skill is a plain-text file — a recipe that tells an AI coach how to help you with a specific moment in your flow cycle. No magic. No proprietary platform required.

Drop them into your system prompt. Reference them in your IDE. Use them with any AI tool that accepts context.

They work best in sequence — but any one of them works on its own.

---

## The Flow Cycle

Stage Manager organizes the builder's work into three nodes:

**Shape** — exploring the problem space before converging on a solution  
**Stage** — building in small, intentional increments with full agency  
**All Nodes** — coherence checks that run at any transition point

The skills support every phase — and the transitions between them.

---

## The 13 Skills

### Shape Node

| Skill | What It Does |
|---|---|
| **Find the Holes** | Maps every place in a spec where a coding tool will invent behavior you didn't ask for. Quote, name, question — before building starts. |
| **Collapsed Options** | Finds decisions you already made without knowing it — especially in the area where you're trying to do something genuinely different. Reopens option space before it closes. |
| **Risk Sequence** | Surfaces the load-bearing assumptions and sequences them by cost-if-wrong. Shows you what to prove first so everything built after is built on solid ground. |
| **Soul Check** | Reads a full artifact for the original animating idea and checks whether it's still alive. A deep 10–15 minute read. For quick transition checks, use Coherence Check. |

### Shape → Stage Transition

| Skill | What It Does |
|---|---|
| **Shape-to-Stage Gate** | Five readiness questions before staging begins. Prevents premature staging (most common) and over-shaping (perfectionism). Runs once, at the boundary, before Chunking. |

### Stage Node

| Skill | What It Does |
|---|---|
| **Chunking** | Breaks a story or feature into flow-cycle-sized pieces — each small enough to prompt cleanly, large enough to produce something testable, sequenced by cost of delay. |
| **Cost of Delay** | Sequences stories and features by what it costs to wait — economic, risk, flow, and joy costs all count equally. Highest cost of delay per unit of size goes first. |
| **Prompt Craft** | Turns a shaped chunk into a prompt a coding tool can execute without inventing what you didn't ask for. Six parts: context, goal, scope, constraints, definition of done, guardrails. |
| **Output Review** | Reads what a coding tool just produced against three layers: definition of done, original intent, what it sets up next. Verdicts: Accept, Revise, or Return. Closes the Stage loop. |

### All Nodes

| Skill | What It Does |
|---|---|
| **Coherence Check** | A lightweight 2-minute gate at any transition point — between shaping and staging, between chunks, after unexpected output, whenever the plot feels lost. For a deep read on a full artifact, use Soul Check. |

---

## How to Read the Suite

**Risk Sequence** retires load-bearing assumptions before building. Once assumptions are confirmed, **Cost of Delay** sequences the confirmed work.

**Find the Holes** maps gaps the AI will invent into. **Collapsed Options** maps decisions the builder already made without knowing it. Run both before staging.

**Soul Check** is a deep read on a single artifact — 10–15 minutes. **Coherence Check** is the lightweight transition gate — 2 minutes, any artifact, any moment of doubt.

**Shape-to-Stage Gate** runs once, at the boundary between shaping and staging, before Chunking begins. **Output Review** closes the Stage loop after each prompt runs.

---

## The Skill Structure

Each SKILL.md contains:

- **Frontmatter** — name and description for skill routing
- **Your Job** — one clear statement of what this skill does
- **Your Posture** — the voice and stance for this moment in the flow cycle
- **How to Receive What Lands** — what to do when the builder arrives with more or less than expected
- **The Core Method** — questions, layers, or steps specific to this skill
- **Output Structure** — what the response looks like
- **Tone Reminders** — what to protect and what to avoid
- **Part of Stage Manager** — where this skill sits in the suite and how it relates to adjacent skills

---

## Repository Structure

```
plugins/stage-manager/skills/
  shape-find-holes/SKILL.md
  shape-collapsed-options/SKILL.md
  shape-risk-sequence/SKILL.md
  shape-soul-check/SKILL.md
  shape-to-stage-gate/SKILL.md
  stage-chunking/SKILL.md
  stage-wsjf/SKILL.md
  stage-prompt-craft/SKILL.md
  stage-output-review/SKILL.md
  coherence-check/SKILL.md

SOUL.md          ← the animating idea behind this library
README.md        ← this file
```

---

## The Soul Document

`SOUL.md` at the root of this repo is the animating idea behind Stage Manager — the mantra, the daily practice, the vision, and what this work is in service of. Read it before reading the skills. It's the context everything else runs through.

---

## Using These Skills

**With Claude or any AI assistant**

Paste a skill's contents into your system prompt or at the top of a conversation. Then describe what you're working on. The skill will shape how the AI responds to you.

**With Claude Code, Cursor, or Replit**

Reference a skill file in your project's instructions or rules file. The coding tool will load it as context for your session.

**As a standalone practice**

Read a skill before starting work. Use it as a checklist or reflection guide. The questions are useful even without an AI.

---

## What's Coming

- Shared references: `invention-zones.md`, `tool-selection-zones.md`, `breakthrough-dimensions.md`
- Card creation skills: Intention Cards, Story Cards, Script Cards
- Session skills (Opening Ritual, Closing Ritual, Pattern Connect) — available inside Stage Manager where session continuity supports them
- Wisdom packs — user-owned domain context that travels across tools
- Stage Manager — the full practice built on this foundation

---

## Made by Manifest AI

These skills are free and open. They are the first taste of deliberate unfolding — available to any builder, right now.

Start here. Feel what it's like to expand options before converging. Then come to Stage Manager for the full practice.

*For the builders who want to lead.*

→ [manifest.ai](https://manifest.ai) · [Stage Manager Skills](https://github.com/Mnfst-AI/Stage_Manager_Skills)

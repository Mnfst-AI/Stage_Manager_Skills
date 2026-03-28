# Stage Manager — Artful Making Skill Library

> **How you move through your work is what you build.**

A free, open collection of 11 skills for vibe coders who want to stay the author while building with AI tools.

These skills help you expand options before converging, maintain coherence across a build, and keep the soul of the work intact while Claude Code, Cursor, Replit, or any agentic coding tool runs at speed.

---

## Three Ways to Install

### Option A: Stage Manager Only

Use this if you just want the 11 Stage Manager skills as slash commands in Claude Code.

```bash
git clone https://github.com/Mnfst-AI/Stage_Manager_Skills.git
cd Stage_Manager_Skills
bash install.sh
```

### Option B: Stage Manager + Enhanced Compound Engineering

Use this if you want the full stack — Stage Manager skills plus the CE pipeline with Stage Manager gates woven into every phase.

**Works whether or not you already have Compound Engineering installed.**

```bash
git clone -b enhanced-cli-skills https://github.com/Mnfst-AI/Stage_Manager_Skills.git
cd Stage_Manager_Skills
bash install-enhanced-ce.sh
```

The installer will:
- Install Compound Engineering from [EveryInc/compound-engineering-plugin](https://github.com/EveryInc/compound-engineering-plugin) if not already present
- Back up stock CE commands to `~/.claude/commands/ce.backup/`
- Overlay enhanced CE commands with Stage Manager gates at every phase
- Symlink all 11 Stage Manager skills
- Link shared reference files

To roll back to stock CE: `cp ~/.claude/commands/ce.backup/* ~/.claude/commands/ce/`

### Option C: Stage Manager + Superpowers

Use this if you're running Superpowers and want Stage Manager shaping skills available in the same session.

```bash
git clone https://github.com/Mnfst-AI/Stage_Manager_Skills.git
cd Stage_Manager_Skills
bash install-superpowers.sh
```

The installer will:
- Verify Superpowers is installed
- Symlink all 11 Stage Manager skills to `~/.claude/skills/`
- Link shared reference files
- Leave Superpowers commands untouched

**The workflow with Superpowers:** Run Stage Manager shape skills to shape and brief your spec, then hand the `Stage_Manager_Brief.md` and your staged spec to Superpowers for planning and execution.

---

## What Is Compound Engineering?

[Compound Engineering](https://every.to/chain-of-thought/compound-engineering-how-every-codes-with-agents) is a methodology and Claude Code plugin from [Every](https://every.to), created by Kieran Klaassen and Dan Shipper. It inverts the typical accumulation of technical debt — each unit of engineering work makes the next unit easier.

CE provides five commands: `/ce:brainstorm`, `/ce:plan`, `/ce:work`, `/ce:review`, `/ce:compound`.

## What Is Superpowers?

[Superpowers](https://github.com/obra/superpowers) is an open-source agentic framework by Jesse Vincent that enforces professional development workflows — TDD, parallel sub-agents, structured planning — in Claude Code. 94,000+ GitHub stars and in the official Anthropic marketplace.

Stage Manager and Superpowers are complementary: Stage Manager shapes your spec *before* Superpowers executes it. Shape first. Stage second.

---

## The Flow

```
Shape skills (any combo)
    → /shape-brief
        → Inline change suggestions (accept/reject)
            → Stage_Manager_Brief.md + [Spec_Name]-Staged.md
                → CE (/ce:brainstorm, /ce:plan, /ce:work)
                   or Superpowers
```

---

## What Stage Manager Adds

### To CE:

| CE Phase | Stage Manager Gate |
|---|---|
| **Brainstorm** | Coherence Check at close |
| **Plan** | Find the Holes + Risk Sequence before work begins |
| **Work** | Prompt Craft before coding, Live Mirror after each session |
| **Review** | Decision Capture — full manifest of tool-made choices |
| **Compound** | Soul Check — ensures documented learning reflects original intent |

### To Superpowers:

Stage Manager runs *before* Superpowers. The `Stage_Manager_Brief.md` and `[Spec_Name]-Staged.md` it produces become the input to Superpowers brainstorming and planning — pre-loaded with resolved spec holes, accepted fixes, open questions the builder hasn't decided, and explicit guardrails for what the agent must not decide silently.

---

## The 11 Skills

### Shape Node

| Skill | Slash Command | What It Does |
|---|---|---|
| **Find the Holes** | `/shape-find-holes` | Maps every place a coding tool will invent behavior you didn't ask for. P1/P2/P3 scoring. Interactive hole resolution. |
| **Collapsed Options** | `/shape-collapsed-options` | Finds decisions you already made without knowing it. P1/P2/P3 scoring. |
| **Risk Sequence** | `/shape-risk-sequence` | Surfaces load-bearing assumptions and sequences by cost-if-wrong. Shows what to prove first. |
| **Soul Check** | `/shape-soul-check` | Deep 10-15 min read on whether the original animating idea is still alive. |
| **Shape Brief** | `/shape-brief` | Synthesizes all shape skill output into ranked top-three problems, inline change suggestions, `Stage_Manager_Brief.md`, and `[Spec_Name]-Staged.md`. The handoff skill. |

### Shape → Stage Transition

| Skill | Slash Command | What It Does |
|---|---|---|
| **Shape-to-Stage Gate** | `/sense-shape-to-stage-gate` | Five readiness questions before staging begins. Verdicts: Ready, Almost, Not Yet. |

### Stage Node

| Skill | Slash Command | What It Does |
|---|---|---|
| **Chunking** | `/stage-chunking` | Breaks work into flow-cycle-sized pieces sequenced by cost of delay — economic, risk, flow, and joy costs scored per chunk. |
| **Prompt Craft** | `/stage-prompt-craft` | Turns a shaped chunk into a scoped, guardrailed prompt. |
| **Live Mirror** | `/stage-live-mirror` | Compares plan vs. code output after a session. Surfaces every invisible decision the tool made. |
| **Decision Capture** | `/stage-decision-capture` | Full decisions-made manifest after a build — every choice the tool made that wasn't in the spec. |

### All Nodes

| Skill | Slash Command | What It Does |
|---|---|---|
| **Coherence Check** | `/coherence-check` | Lightweight 2-min gate at any transition point mid-build. For the shape/stage boundary, use Shape Brief instead. |

---

## How to Read the Suite

**The Shape Brief flow:** Run any combination of shape skills (Find the Holes → Collapsed Options → Risk Sequence → Soul Check), then run `/shape-brief`. It synthesizes the findings, presents inline change suggestions you accept or reject, and produces two handoff documents: `Stage_Manager_Brief.md` and `[Spec_Name]-Staged.md`.

**Three handoff paths from Shape Brief:**
- **Brief only** — hand `Stage_Manager_Brief.md` to CE or Superpowers
- **Brief + original spec** — hand both when the full source context matters
- **Brief + Staged spec** — hand both when you walked through fixes and want the next tool building from the resolved version

**Risk Sequence** retires load-bearing assumptions before building. **Chunking** sequences confirmed work by cost of delay — both economic and felt costs.

**Shape-to-Stage Gate** runs once at the boundary between shaping and staging. **Coherence Check** is the lightweight pulse check mid-build — any time something feels off.

**Live Mirror** catches invisible decisions per-session. **Decision Capture** catches everything across the full build.

---

## The Flow Cycle

Stage Manager organizes the builder's work into two nodes and a transition:

**Shape** — exploring the problem space before converging on a solution
**Shape → Stage** — the readiness gate and brief generation
**Stage** — building in small, intentional increments with full agency

---

## Repository Structure

```
install.sh                                     ← standalone Stage Manager installer
install-enhanced-ce.sh                         ← Stage Manager + enhanced CE installer
install-superpowers.sh                         ← Stage Manager + Superpowers installer

plugins/stage-manager/skills/
  shape-find-holes/SKILL.md
  shape-collapsed-options/SKILL.md
  shape-risk-sequence/SKILL.md
  shape-soul-check/SKILL.md
  shape-brief/SKILL.md                         ← NEW
  shape-to-stage-gate/SKILL.md
  stage-chunking/SKILL.md                      ← updated: CoD sequencing built in
  stage-prompt-craft/SKILL.md
  stage-live-mirror/SKILL.md
  stage-decision-capture/SKILL.md
  coherence-check/SKILL.md                     ← updated: Shape Brief pointer added

plugins/compound-engineering/commands/ce/      ← enhanced CE with Stage Manager gates
  brainstorm.md
  plan.md
  work.md
  review.md
  compound.md

plugins/shared/references/
  invention-zones.md
  tool-selection-zones.md
  breakthrough-dimensions.md

stage-manager-soul.md     ← the animating philosophy
README.md                 ← this file
```

---

## Using These Skills

**With Claude Code (recommended)**

Run any installer above. All 11 skills appear as `/slash-commands` in Claude Code.

**With Cursor, Replit, or any AI coding tool**

Reference a skill file in your project's instructions or rules file.

**With Superpowers**

Run `install-superpowers.sh`. Shape with Stage Manager skills, then hand `Stage_Manager_Brief.md` and `[Spec_Name]-Staged.md` to Superpowers for planning and execution.

**With Claude or any AI assistant**

Paste a skill's contents into your system prompt or at the top of a conversation.

**As a standalone practice**

Read a skill before starting work. The questions are useful even without an AI.

---

## Made by Manifest AI

These skills are free and open. They are the first taste of deliberate unfolding — available to any builder, right now.

The enhanced Compound Engineering integration is built on the excellent work of [Every](https://every.to) and their [Compound Engineering plugin](https://github.com/EveryInc/compound-engineering-plugin).

The Superpowers integration is built alongside the excellent work of [Jesse Vincent](https://github.com/obra) and the [Superpowers framework](https://github.com/obra/superpowers).

Shape first. Stage second. Stay the author.

> [manifest.ai](https://manifest.ai) · [Stage Manager Skills](https://github.com/Mnfst-AI/Stage_Manager_Skills)

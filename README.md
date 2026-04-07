# Stage Manager — Artful Making Skill Library

> **How you move through your work is what you build.**

A free, open collection of 16 skills for vibe coders who want to stay the author while building with AI tools.

These skills help you validate before building, expand options before converging, maintain coherence across a build, and keep the soul of the work intact while Claude Code, Cursor, Replit, or any agentic coding tool runs at speed.

---

## Install

```bash
git clone https://github.com/Mnfst-AI/Stage_Manager_Skills.git
cd Stage_Manager_Skills
bash install.sh
```

All 16 skills appear as `/slash-commands` in Claude Code. Start a session with `/sm:stage-manage`.

---

## The 16 Skills

### Validate (prove the premise before building)

| Skill | Slash Command | What It Does |
|---|---|---|
| **YAGNI** | `/sm:yagni` | Gate: challenges the premise before a single line of code. "What did you find out, and who told you?" |
| **Invalidation Prep** | `/sm:invalidate-prep` | Excavates and ranks assumptions, identifies personas, generates problem statements. |
| **Invalidation Interview** | `/sm:invalidate-interview` | Generates a live interview script using negative framing to kill assumptions. |
| **Invalidation Score** | `/sm:invalidate-score` | Scores each assumption as validated, invalidated, or still open. Surfaces pull signals. |

### Shape (analyze before building)

| Skill | Slash Command | What It Does |
|---|---|---|
| **Find the Holes** | `/sm:shape:find-holes` | Maps every place a coding tool will invent behavior you didn't ask for. |
| **Collapsed Options** | `/sm:shape:collapsed-options` | Finds decisions you already made without knowing it. |
| **Risk Sequence** | `/sm:shape:risk-sequence` | Surfaces load-bearing assumptions and sequences by cost-if-wrong. |
| **Soul Check** | `/sm:shape:soul-check` | Deep read on whether the original animating idea is still alive. |
| **Shape Brief** | `/sm:shape:brief` | Synthesizes all shape skill output into ranked problems, inline change suggestions, and handoff documents. |

### Shape → Stage Transition

| Skill | Slash Command | What It Does |
|---|---|---|
| **Shape-to-Stage Gate** | `/sm:shape:gate` | Five readiness questions before staging begins. |

### Stage (before, during, and after the build)

| Skill | Slash Command | What It Does |
|---|---|---|
| **Chunking** | `/sm:stage:chunking` | Breaks work into flow-cycle-sized pieces sequenced by cost of delay. |
| **Prompt Craft** | `/sm:stage:prompt-craft` | Turns a shaped chunk into a scoped, guardrailed prompt. |
| **Live Mirror** | `/sm:stage:live-mirror` | Compares plan vs. code output after a session. Surfaces invisible decisions. |
| **Decision Capture** | `/sm:stage:decision-capture` | Full decisions-made manifest after a build. |

### Any Node

| Skill | Slash Command | What It Does |
|---|---|---|
| **Coherence Check** | `/sm:coherence-check` | Lightweight 2-min gate at any transition point mid-build. |
| **Stage Manage** | `/sm:stage-manage` | Session opener and orchestrator. Watches for signals and suggests skills. |

---

## The Flows

### Validation Flow

```
/sm:yagni → /sm:invalidate-prep → /sm:invalidate-interview → /sm:invalidate-score → build
```

### Shape Brief Flow

```
Shape skills (any combo) → /sm:shape:brief → Stage_Manager_Brief.md
```

### Session Flow

```
/sm:stage-manage → watches for signals → suggests the right skill at the right moment
```

---

## How to Read the Suite

**Start with `/sm:stage-manage`** to open a session. It reads your project context and watches for signals — surfacing the right skill when it sees one.

**The validation flow** runs when you have a new idea. YAGNI asks the hard question. If you can't answer it, Invalidation Prep → Interview → Score walks you through finding out.

**The Shape Brief flow** runs any combination of shape skills, then synthesizes findings into ranked problems with inline change suggestions and handoff documents.

**Coherence Check** is the lightweight pulse check — any time something feels off mid-build.

**Live Mirror** catches invisible decisions per-session. **Decision Capture** catches everything across the full build.

---

## Repository Structure

```
install.sh                                     ← installer

plugins/stage-manager/skills/
  yagni/SKILL.md
  invalidate-prep/SKILL.md
  invalidate-interview/SKILL.md
  invalidate-score/SKILL.md
  shape-find-holes/SKILL.md
  shape-collapsed-options/SKILL.md
  shape-risk-sequence/SKILL.md
  shape-soul-check/SKILL.md
  shape-brief/SKILL.md
  shape-to-stage-gate/SKILL.md
  stage-chunking/SKILL.md
  stage-prompt-craft/SKILL.md
  stage-live-mirror/SKILL.md
  stage-decision-capture/SKILL.md
  coherence-check/SKILL.md
  stage-manage/SKILL.md

plugins/shared/references/
  invention-zones.md
  tool-selection-zones.md
  breakthrough-dimensions.md

stage-manager-soul.md     ← the animating philosophy
```

---

## Using These Skills

**With Claude Code** — Run `bash install.sh`. All 16 skills appear as slash commands.

**With Cursor, Replit, or any AI coding tool** — Reference a skill file in your project's instructions or rules file.

**With Claude or any AI assistant** — Paste a skill's contents into your system prompt or at the top of a conversation.

**As a standalone practice** — Read a skill before starting work. The questions are useful even without an AI.

---

## Made by MNFST Ai

These skills are free and open. They are the first taste of deliberate unfolding — available to any builder, right now.

Shape first. Stage second. Stay the author.

> [MNFST.AI](https://manifest.ai) · [Stage Manager Skills](https://github.com/Mnfst-AI/Stage_Manager_Skills)

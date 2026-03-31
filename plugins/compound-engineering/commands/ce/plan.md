---
name: ce:plan
description: Transform feature descriptions into well-structured project plans following conventions
argument-hint: "[feature description, bug report, or improvement idea]"
---

# Create a plan for a new feature or bug fix

## Introduction

**Note: The current year is 2026.** Use this when dating plans and searching for recent documentation.

Transform feature descriptions, bug reports, or improvement ideas into well-structured markdown files issues that follow project conventions and best practices. This command provides flexible detail levels to match your needs.

## Feature Description

<feature_description> #$ARGUMENTS </feature_description>

**If the feature description above is empty, ask the user:** "What would you like to plan? Please describe the feature, bug fix, or improvement you have in mind."

Do not proceed until you have a clear feature description from the user.

### 0. Idea Refinement

**Check for brainstorm output first:**

Before asking questions, look for recent brainstorm documents in `docs/brainstorms/` that match this feature:

```bash
ls -la docs/brainstorms/*.md 2>/dev/null | head -10
```

**Relevance criteria:** A brainstorm is relevant if:
- The topic (from filename or YAML frontmatter) semantically matches the feature description
- Created within the last 14 days
- If multiple candidates match, use the most recent one

**If a relevant brainstorm exists:**
1. Read the brainstorm document **thoroughly** — every section matters
2. Announce: "Found brainstorm from [date]: [topic]. Using as foundation for planning."
3. Extract and carry forward **ALL** of the following into the plan:
   - Key decisions and their rationale
   - Chosen approach and why alternatives were rejected
   - Constraints and requirements discovered during brainstorming
   - Open questions (flag these for resolution during planning)
   - Success criteria and scope boundaries
   - Any specific technical choices or patterns discussed
   - **Shaping decisions** (if Stage Manager skills were run during brainstorming — carry forward all resolved holes, collapsed options, and risk sequences)
4. **Skip the idea refinement questions below** — the brainstorm already answered WHAT to build
5. Use brainstorm content as the **primary input** to research and planning phases
6. **Critical: The brainstorm is the origin document.** Throughout the plan, reference specific decisions with `(see brainstorm: docs/brainstorms/<filename>)` when carrying forward conclusions. Do not paraphrase decisions in a way that loses their original context — link back to the source.
7. **Do not omit brainstorm content** — if the brainstorm discussed it, the plan must address it (even if briefly). Scan each brainstorm section before finalizing the plan to verify nothing was dropped.

**If multiple brainstorms could match:**
Use **AskUserQuestion tool** to ask which brainstorm to use, or whether to proceed without one.

**If no brainstorm found (or not relevant), run idea refinement:**

Refine the idea through collaborative dialogue using the **AskUserQuestion tool**:

- Ask questions one at a time to understand the idea fully
- Prefer multiple choice questions when natural options exist
- Focus on understanding: purpose, constraints and success criteria
- Continue until the idea is clear OR user says "proceed"

**Gather signals for research decision.** During refinement, note:

- **User's familiarity**: Do they know the codebase patterns? Are they pointing to examples?
- **User's intent**: Speed vs thoroughness? Exploration vs execution?
- **Topic risk**: Security, payments, external APIs warrant more caution
- **Uncertainty level**: Is the approach clear or open-ended?

**Skip option:** If the feature description is already detailed, offer:
"Your description is clear. Should I proceed with research, or would you like to refine it further?"

## Main Tasks

### 1. Local Research (Always Runs - Parallel)

<thinking>
First, I need to understand the project's conventions, existing patterns, and any documented learnings. This is fast and local - it informs whether external research is needed.
</thinking>

Run these agents **in parallel** to gather local context:

- Task repo-research-analyst(feature_description)
- Task learnings-researcher(feature_description)

**What to look for:**
- **Repo research:** existing patterns, CLAUDE.md guidance, technology familiarity, pattern consistency
- **Learnings:** documented solutions in `docs/solutions/` that might apply (gotchas, patterns, lessons learned)

These findings inform the next step.

### 1.5. Research Decision

Based on signals from Step 0 and findings from Step 1, decide on external research.

**High-risk topics → always research.** Security, payments, external APIs, data privacy. The cost of missing something is too high. This takes precedence over speed signals.

**Strong local context → skip external research.** Codebase has good patterns, CLAUDE.md has guidance, user knows what they want. External research adds little value.

**Uncertainty or unfamiliar territory → research.** User is exploring, codebase has no examples, new technology. External perspective is valuable.

**Announce the decision and proceed.** Brief explanation, then continue. User can redirect if needed.

### 1.5b. External Research (Conditional)

**Only run if Step 1.5 indicates external research is valuable.**

Run these agents in parallel:

- Task best-practices-researcher(feature_description)
- Task framework-docs-researcher(feature_description)

### 1.6. Consolidate Research

After all research steps complete, consolidate findings:

- Document relevant file paths from repo research
- **Include relevant institutional learnings** from `docs/solutions/`
- Note external documentation URLs and best practices (if external research was done)
- List related issues or PRs discovered
- Capture CLAUDE.md conventions

### 2. Stage Manager Shaping Gate (NEW)

Before planning, check if the feature should go through shaping.

**Auto-trigger shaping if:**
- The brainstorm has no "Shaping Decisions" section (shaping wasn't run during brainstorming)
- The feature is complex (A LOT detail level)
- The feature involves architecture decisions, new integrations, or user-facing behavior changes

**Offer shaping:**

Use **AskUserQuestion tool**:

**Question:** "Before planning — want to run Stage Manager shaping to surface invisible decisions?"

**Options:**
1. **Quick shaping (Find the Holes only)** — 2 minutes, surfaces spec gaps where coding tools will invent (Recommended for most features)
2. **Full shaping pass** — 5-8 minutes, runs Find the Holes + Collapsed Options + Risk Sequence
3. **Shape-to-Stage Gate** — 5 readiness questions to check if this is ready for planning
4. **Skip shaping** — Proceed directly to planning

**If shaping is run:**
- Run the selected skill(s) on the brainstorm or feature description
- Carry all resolved decisions into the plan
- Add a "## Shaping Context" section to the plan with: holes found, decisions made, risks identified
- Reference shaping findings throughout the plan where relevant

### 3. Issue Planning & Structure

<thinking>
Think like a product manager - what would make this issue clear and actionable? Consider multiple perspectives
</thinking>

**Title & Categorization:**

- [ ] Draft clear, searchable issue title using conventional format
- [ ] Determine issue type: enhancement, bug, refactor
- [ ] Convert title to filename with date prefix and -plan suffix

**Stakeholder Analysis:**

- [ ] Identify who will be affected by this issue
- [ ] Consider implementation complexity and required expertise

### 4. SpecFlow Analysis

After planning the issue structure, run SpecFlow Analyzer to validate and refine:

- Task compound-engineering:workflow:spec-flow-analyzer(feature_description, research_findings)

### 5. Choose Implementation Detail Level

Select how comprehensive you want the issue to be, simpler is mostly better.

#### 📄 MINIMAL (Quick Issue)

**Best for:** Simple bugs, small improvements, clear features

**Includes:**
- Problem statement or feature description
- Basic acceptance criteria
- Essential context only

**Structure:**

````markdown
---
title: [Issue Title]
type: [feat|fix|refactor]
status: active
date: YYYY-MM-DD
origin: docs/brainstorms/YYYY-MM-DD-<topic>-brainstorm.md  # if originated from brainstorm
shaping: [holes found, decisions made]  # if Stage Manager shaping was run
---

# [Issue Title]

[Brief problem/feature description]

## Shaping Context
[If Stage Manager skills were run — summarize key findings: holes resolved, collapsed options surfaced, risks identified. Reference the full shaping analysis if saved to /docs.]

## Acceptance Criteria

- [ ] Core requirement 1
- [ ] Core requirement 2

## Context

[Any critical information]

## Sources

- **Origin brainstorm:** [path] — include if plan originated from a brainstorm
- **Shaping analysis:** [path] — include if Stage Manager shaping was run
- Related issue: #[issue_number]
````

#### 📋 MORE (Standard Issue)

**Best for:** Most features, complex bugs, team collaboration

**Includes everything from MINIMAL plus:**
- Detailed background and motivation
- Technical considerations
- Shaping context with resolved decisions
- Success metrics
- Dependencies and risks

#### 📚 A LOT (Comprehensive Issue)

**Best for:** Major features, architectural changes, complex integrations

**Includes everything from MORE plus:**
- Detailed implementation plan with phases
- Alternative approaches considered
- Shaping decisions manifest (every hole resolved, every collapsed option addressed)
- Risk sequence with mitigation strategies
- Prompt guard notes (what the prompts should and shouldn't specify)

### 6. Stage Manager Chunking & Sequencing (NEW)

After the plan is written, offer to break it into buildable pieces using Stage Manager staging skills.

Use **AskUserQuestion tool**:

**Question:** "Plan is ready. Want to break it into sequenced, prompt-ready chunks?"

**Options:**
1. **Chunk and sequence** — Run `/sm:stage:chunking` + `/sm:stage:wsjf` to break into flow-cycle-sized pieces ordered by cost of delay
2. **Chunk, sequence, and craft prompts** — Also run `/sm:stage:prompt-craft` to generate paste-ready prompts for each chunk
3. **Skip** — Keep the plan as-is for `/ce:work`

**If chunking is run:**
- Append the chunked stories and sequence to the plan under "## Implementation Sequence"
- If prompts are crafted, run `/sm:stage:prompt-guard` on each to flag prompt inventions before they reach the coding tool
- Add prompt-guard annotations to the plan

### 7. Final Review & Submission

**Brainstorm cross-check (if plan originated from a brainstorm):**

Before finalizing, re-read the brainstorm document and verify:
- [ ] Every key decision from the brainstorm is reflected in the plan
- [ ] Shaping decisions (if any) are carried forward
- [ ] The chosen approach matches what was decided
- [ ] Open questions are either resolved or flagged
- [ ] The `origin:` frontmatter field points to the brainstorm file

## Write Plan File

**REQUIRED: Write the plan file to disk before presenting any options.**

```bash
mkdir -p docs/plans/
```

Use the Write tool to save the complete plan to `docs/plans/YYYY-MM-DD-<type>-<descriptive-name>-plan.md`.

## Post-Generation Options

After writing the plan file, use the **AskUserQuestion tool** to present these options:

**Question:** "Plan ready at `docs/plans/[filename]`. What would you like to do next?"

**Options:**
1. **Open plan in editor** - Open the plan file for review
2. **Run `/deepen-plan`** - Enhance with parallel research agents
3. **Run Stage Manager shaping** - Surface invisible decisions (if not done yet)
4. **Run `/sm:stage:prompt-craft`** - Generate paste-ready prompts for each section
5. **Review and refine** - Improve through structured self-review
6. **Share to Proof** - Upload for collaborative review
7. **Start `/ce:work`** - Begin implementing this plan locally
8. **Create Issue** - Create issue in project tracker

NEVER CODE! Just research and write the plan.

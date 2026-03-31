---
name: ce:work
description: Execute work plans efficiently while maintaining quality and finishing features
argument-hint: "[plan file, specification, or todo file path]"
---

# Work Plan Execution Command

Execute a work plan efficiently while maintaining quality and finishing features.

## Introduction

This command takes a work document (plan, specification, or todo file) and executes it systematically. The focus is on **shipping complete features** by understanding requirements quickly, following existing patterns, and maintaining quality throughout.

**Stage Manager integration:** This version includes Live Mirror checkpoints that surface invisible decisions the coding tool makes during execution.

## Input Document

<input_document> #$ARGUMENTS </input_document>

## Execution Workflow

### Phase 1: Quick Start

1. **Read Plan and Clarify**

   - Read the work document completely
   - Review any references or links provided in the plan
   - If anything is unclear or ambiguous, ask clarifying questions now
   - **Check for Shaping Context:** If the plan has a "Shaping Context" section, read it carefully — these are the builder's explicit decisions that must be preserved during coding
   - **Check for Prompt Guard annotations:** If prompts were guarded, note which specifications are the builder's decisions vs. prompt inventions
   - Get user approval to proceed
   - **Do not skip this** - better to ask questions now than build the wrong thing

2. **Setup Environment**

   First, check the current branch:

   ```bash
   current_branch=$(git branch --show-current)
   default_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
   if [ -z "$default_branch" ]; then
     default_branch=$(git rev-parse --verify origin/main >/dev/null 2>&1 && echo "main" || echo "master")
   fi
   ```

   **If already on a feature branch** (not the default branch):
   - Ask: "Continue working on `[current_branch]`, or create a new branch?"

   **If on the default branch**, choose how to proceed:

   **Option A: Create a new branch**
   ```bash
   git pull origin [default_branch]
   git checkout -b feature-branch-name
   ```

   **Option B: Use a worktree (recommended for parallel development)**
   ```bash
   skill: git-worktree
   ```

   **Option C: Continue on the default branch**
   - Requires explicit user confirmation

3. **Create Todo List**
   - Use TodoWrite to break plan into actionable tasks
   - Include dependencies between tasks
   - Prioritize based on what needs to be done first
   - Include testing and quality check tasks
   - **Add Live Mirror checkpoints** after significant implementation milestones (see Phase 2)

### Phase 2: Execute

1. **Task Execution Loop**

   For each task in priority order:

   ```
   while (tasks remain):
     - Mark task as in_progress in TodoWrite
     - Read any referenced files from the plan
     - Look for similar patterns in codebase
     - Implement following existing conventions
     - Write tests for new functionality
     - Run System-Wide Test Check (see below)
     - Run tests after changes
     - Mark task as completed in TodoWrite
     - Mark off the corresponding checkbox in the plan file ([ ] → [x])
     - Evaluate for incremental commit (see below)
     - **Evaluate for Live Mirror checkpoint (see below)**
   ```

   **System-Wide Test Check** — Before marking a task done, pause and ask:

   | Question | What to do |
   |----------|------------|
   | **What fires when this runs?** | Read the actual code for callbacks, middleware, `after_*` hooks. |
   | **Do my tests exercise the real chain?** | Write at least one integration test with real objects. |
   | **Can failure leave orphaned state?** | Trace the failure path. Test cleanup or idempotency. |
   | **What other interfaces expose this?** | Grep for the method in related classes. |
   | **Do error strategies align across layers?** | Verify rescue lists match what lower layers raise. |

   **Live Mirror Checkpoints (NEW)** — After completing a significant milestone (completing a major component, finishing a phase, or after every 3-5 tasks), offer a Live Mirror check:

   Use **AskUserQuestion tool**:

   **Question:** "[X] tasks completed. Want to run a Live Mirror to see what the coding tool invented?"

   **Options:**
   1. **Run Live Mirror** — Compare the plan to what was just built. Surface invisible decisions. (~1 min)
   2. **Skip for now** — Continue building, mirror later
   3. **Turn off mirror checkpoints** — Don't ask again during this session

   **If Live Mirror is run:**
   - Run `/sm:stage:live-mirror` with the plan as spec and the current git diff as output
   - Present findings
   - For any ⚠️ or 🔴 items, ask the builder: accept, modify, or revert
   - Update the plan's "Shaping Context" section with new decisions made

2. **Incremental Commits**

   After completing each task, evaluate whether to create an incremental commit:

   | Commit when... | Don't commit when... |
   |----------------|---------------------|
   | Logical unit complete | Small part of a larger unit |
   | Tests pass + meaningful progress | Tests failing |
   | About to switch contexts | Purely scaffolding |
   | About to attempt risky changes | Would need a "WIP" message |

3. **Follow Existing Patterns**

   - The plan should reference similar code - read those files first
   - Match naming conventions exactly
   - Reuse existing components where possible
   - Follow project coding standards (see CLAUDE.md)

4. **Test Continuously**

   - Run relevant tests after each significant change
   - Don't wait until the end to test
   - Fix failures immediately
   - Add new tests for new functionality

5. **Track Progress**
   - Keep TodoWrite updated as you complete tasks
   - Note any blockers or unexpected discoveries
   - Create new tasks if scope expands

### Phase 3: Quality Check

1. **Run Core Quality Checks**

   ```bash
   # Run full test suite
   # Run linting (per CLAUDE.md)
   ```

2. **Run Decision Capture (NEW)**

   Before creating the PR, run `/sm:stage:decision-capture` on the full build:

   ```
   Plan: [plan file path]
   Build: git diff [default_branch]...HEAD
   ```

   This generates the decisions-made manifest — every choice the coding tool made that wasn't in the plan.

   Present the manifest to the builder. For high-impact inventions, ask: accept, modify, or revert.

   **Include the manifest summary in the PR description** under a "## Decisions Made During Build" section.

3. **Consider Reviewer Agents** (Optional)

   Use for complex, risky, or large changes. Feed the decision-capture manifest to review agents as additional context.

4. **Final Validation**
   - All TodoWrite tasks marked completed
   - All tests pass
   - Linting passes
   - Code follows existing patterns
   - Decision capture reviewed — no unaccepted high-impact inventions

5. **Prepare Operational Validation Plan** (REQUIRED)
   - Add `## Post-Deploy Monitoring & Validation` section to PR description
   - Include log queries, metrics, expected signals, failure signals, rollback triggers

### Phase 4: Ship It

1. **Create Commit**

   ```bash
   git add <files related to this feature>  # Stage specific files, not `git add .`
   git status
   git diff --staged

   git commit -m "$(cat <<'EOF'
   feat(scope): description of what and why

   Brief explanation if needed.

   🤖 Generated with [Claude Code](https://claude.com/claude-code)

   Co-Authored-By: Claude <noreply@anthropic.com>
   EOF
   )"
   ```

2. **Create Pull Request**

   ```bash
   git push -u origin feature-branch-name

   gh pr create --title "Feature: [Description]" --body "$(cat <<'EOF'
   ## Summary
   - What was built
   - Why it was needed
   - Key decisions made

   ## Decisions Made During Build
   [Summary from Decision Capture manifest]
   - **Specified by builder:** X decisions
   - **Invented by coding tool:** Y decisions (Z accepted, W modified)
   - **High-impact inventions:** [list any that were flagged]

   ## Testing
   - Tests added/modified
   - Manual testing performed

   ## Post-Deploy Monitoring & Validation
   - What to monitor
   - Expected healthy behavior
   - Failure signals / rollback trigger

   ---

   [![Compound Engineered](https://img.shields.io/badge/Compound-Engineered-6366f1)](https://github.com/EveryInc/compound-engineering-plugin) [![Stage Managed](https://img.shields.io/badge/Stage-Managed-a78bfa)](https://github.com/Mnfst-AI/Stage_Manager_Skills) 🤖 Generated with [Claude Code](https://claude.com/claude-code)
   EOF
   )"
   ```

3. **Update Plan Status** — set to `completed`

4. **Notify User** — Summarize, link PR, note follow-ups

---

## Key Principles

### The Mirror Never Goes Dark

Stage Manager's Live Mirror and Decision Capture ensure that invisible decisions are surfaced *during* the build, not discovered weeks later. The builder stays in the driver's seat.

### Start Fast, Execute Faster

- Get clarification once at the start, then execute
- Live Mirror checkpoints are optional and quick (~1 min each)
- The goal is to **finish the feature with full awareness**

### Quality is Built In

- Follow existing patterns
- Write tests for new code
- Run linting before pushing
- Decision Capture before PR ensures nothing slipped through

### Ship Complete Features

- Mark all tasks completed before moving on
- Don't leave features 80% done
- A finished feature with a decisions manifest beats a perfect feature that nobody understands

## Quality Checklist

Before creating PR, verify:

- [ ] All TodoWrite tasks marked completed
- [ ] Tests pass
- [ ] Linting passes
- [ ] Code follows existing patterns
- [ ] Decision Capture manifest reviewed
- [ ] No unaccepted high-impact inventions
- [ ] PR description includes Decisions Made section
- [ ] PR description includes Post-Deploy Monitoring section
- [ ] PR description includes Stage Managed badge

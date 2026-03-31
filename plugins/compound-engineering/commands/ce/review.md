---
name: ce:review
description: Perform exhaustive code reviews using multi-agent analysis, ultra-thinking, and worktrees
argument-hint: "[PR number, GitHub URL, branch name, or latest]"
---

# Review Command

<command_purpose> Perform exhaustive code reviews using multi-agent analysis, ultra-thinking, and Git worktrees for deep local inspection. Enhanced with Stage Manager's Decision Capture for invisible decision surfacing. </command_purpose>

## Introduction

<role>Senior Code Review Architect with expertise in security, performance, architecture, and quality assurance</role>

## Prerequisites

<requirements>
- Git repository with GitHub CLI (`gh`) installed and authenticated
- Clean main/master branch
- Proper permissions to create worktrees and access the repository
- For document reviews: Path to a markdown file or document
</requirements>

## Main Tasks

### 1. Determine Review Target & Setup (ALWAYS FIRST)

<review_target> #$ARGUMENTS </review_target>

#### Immediate Actions:

- [ ] Determine review type: PR number, GitHub URL, file path (.md), or empty (current branch)
- [ ] Check current git branch
- [ ] If ALREADY on the target branch → proceed
- [ ] If DIFFERENT branch → offer worktree: `skill: git-worktree`
- [ ] Fetch PR metadata using `gh pr view --json`
- [ ] Set up analysis tools
- [ ] Make sure we are on the branch we are reviewing

#### Protected Artifacts

<protected_artifacts>
- `docs/plans/*.md` — Plan files created by `/ce:plan`
- `docs/solutions/*.md` — Solution documents
- `docs/brainstorms/*.md` — Brainstorm documents
- Shaping analysis files in `docs/` — Stage Manager output
</protected_artifacts>

#### Load Review Agents

Read `compound-engineering.local.md` in the project root. If found, use `review_agents` from YAML frontmatter. If no settings file exists, invoke the `setup` skill to create one.

#### Parallel Agents to review the PR:

Run all configured review agents in parallel using Task tool.

Additionally, always run these regardless of settings:
- Task agent-native-reviewer(PR content)
- Task learnings-researcher(PR content)

#### Stage Manager Decision Capture (NEW)

**Always run alongside the review agents:**

- Run `/sm:stage:decision-capture` on the PR:
  - **Plan:** Look for the plan file referenced in the PR description or in `docs/plans/` matching the branch name
  - **Build:** The PR diff itself

This produces the decisions-made manifest — every choice the coding tool made that wasn't in the plan. Feed this manifest to all review agents as additional context.

**Why this matters:** Standard code review catches bugs and style issues. Decision Capture catches the *invisible decisions* — the architectural choices, library selections, and pattern decisions that were made silently. This is the review dimension no other tool covers.

#### Conditional Agents (Run if applicable):

**MIGRATIONS:** If PR contains database migrations, schema.rb, or data backfills:
- Task schema-drift-detector(PR content)
- Task data-migration-expert(PR content)
- Task deployment-verification-agent(PR content)

### 2. Ultra-Thinking Deep Dive Phases

#### Phase 1: Stakeholder Perspective Analysis

1. **Developer Perspective** — Understandability, APIs, debugging, testing
2. **Operations Perspective** — Deploy safety, metrics, troubleshooting, resources
3. **End User Perspective** — Intuitive, error messages, performance, problem-solving
4. **Security Team Perspective** — Attack surface, compliance, data protection, audit
5. **Business Perspective** — ROI, legal risks, time-to-market, TCO

#### Phase 2: Scenario Exploration

- [ ] Happy Path, Invalid Inputs, Boundary Conditions
- [ ] Concurrent Access, Scale Testing, Network Issues
- [ ] Resource Exhaustion, Security Attacks
- [ ] Data Corruption, Cascading Failures

### 3. Multi-Angle Review Perspectives

- Technical Excellence, Business Value, Risk Management, Team Dynamics

### 4. Simplification and Minimalism Review

Run Task code-simplicity-reviewer()

### 5. Findings Synthesis and Todo Creation

#### Step 1: Synthesize All Findings

- [ ] Collect findings from all parallel agents
- [ ] **Integrate Decision Capture manifest** — any Invented ⚠️ or Adapted 🔄 decisions with High impact become automatic P2 findings
- [ ] Any 🔴 Conflicts-with-spec decisions from the manifest become P1 findings
- [ ] Surface learnings-researcher results
- [ ] Discard findings about protected artifacts
- [ ] Categorize by type: security, performance, architecture, quality, **invisible-decisions**
- [ ] Assign severity: 🔴 P1, 🟡 P2, 🔵 P3
- [ ] Remove duplicates

#### Step 2: Create Todo Files

Create todo files for ALL findings immediately using file-todos skill.

**New category: invisible-decisions**
For findings sourced from the Decision Capture manifest, tag with `invisible-decision` and include:
- What was specified vs. what was built
- Whether the invention was accepted during `ce:work` (if Live Mirror was run)
- Impact and reversibility assessment

#### Step 3: Summary Report

````markdown
## ✅ Code Review Complete

**Review Target:** PR #XXXX - [PR Title]

### Decisions Analysis (Stage Manager)
- **Total decisions in build:** [X]
- **Specified by builder:** [X] ✅
- **Invented by coding tool:** [X] ⚠️
- **Adapted from spec:** [X] 🔄
- **High-impact inventions flagged:** [X]

### Findings Summary:
- **Total Findings:** [X]
- **🔴 CRITICAL (P1):** [count] - BLOCKS MERGE
- **🟡 IMPORTANT (P2):** [count] - Should Fix
- **🔵 NICE-TO-HAVE (P3):** [count] - Enhancements

### Created Todo Files:
[list by priority]

### Review Agents Used:
[list agents + Stage Manager Decision Capture]
````

### 6. End-to-End Testing (Optional)

Detect project type and offer appropriate testing.

### Important: P1 Findings Block Merge

Any **🔴 P1 (CRITICAL)** findings — including spec conflicts from Decision Capture — must be addressed before merging.

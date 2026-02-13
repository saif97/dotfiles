---
description: Add a memo to agent memory (AGENTS.md), ensuring alignment with system instructions
---

# Add Memo to Agent Memory

## User Memo
$ARGUMENTS

## Current System Instructions
@AGENTS.md

## Current AI System Instructions
@ai/aiSystemInstructions.md

## Your Task

You are updating the project's agent memory (`AGENTS.md`) with the user's memo above.

### Step 1: Alignment Check
Before adding the memo, review the current `AGENTS.md` and `ai/aiSystemInstructions.md` content. Check if the memo:
- **Contradicts** any existing rule or instruction — if so, flag the conflict to the user and ask how to resolve it before making changes.
- **Duplicates** something already documented — if so, tell the user it's already covered and skip the addition.
- **Extends or refines** an existing rule — if so, update the existing section rather than appending a duplicate.

### Step 2: Update AGENTS.md
If the memo is aligned and non-duplicate:
1. Determine the most appropriate section in `AGENTS.md` to place this memo. If no fitting section exists, create one with a clear heading.
2. Write the memo in a concise, imperative style consistent with the existing tone of `AGENTS.md`.
3. Do NOT remove or rewrite existing content — only add or refine.

### Step 3: Confirm
After updating, briefly summarize:
- What was added or changed
- Where it was placed in `AGENTS.md`
- Any conflicts that were detected and how they were resolved

---
description: Commit logically relted code
allowed-tools: Bash(git diff:*), Bash(git status:*), Bash(git log:*), Bash(git add:*), Bash(git commit:*), Bash(git reset HEAD:*), Bash(git diff -p:*), Read, Grep, Glob
---

# Smart Commit - Group & Commit Related Changes

## Current State

### Working Tree Status
!`git status --porcelain`

### Staged Changes
!`git diff --cached --stat 2>/dev/null || echo "No staged changes"`

### Unstaged Changes (detail)
!`git diff --stat 2>/dev/null || echo "No unstaged changes"`

### Untracked Files
!`git ls-files --others --exclude-standard 2>/dev/null`

### Recent Commit Style
!`git log --oneline -5 2>/dev/null`

## Your Task

Analyze ALL modified, staged, and untracked files in the working tree. Your goal is to create **focused, atomic commits** where each commit contains only logically related changes.

### Step 1: Analyze Changes at Hunk Level

- Run `git diff -p` to get the full patch output for every modified file
- For untracked files, read their contents to understand their purpose
- Analyze each **hunk** individually — a single file may contain hunks belonging to different logical groups
- Understand the semantic meaning of each change (what feature/fix/config does it relate to?)

### Step 2: Group Related Hunks

- Cluster hunks (across files) that are logically related into groups
- A group = one coherent, atomic change (e.g., a feature + its tests, config for one tool, a single bug fix)
- **Hunks within the same file may belong to different groups** — that's expected
- Each group should represent ONE purpose that makes sense as a single commit

### Step 3: Present ONE Group at a Time

Present the **first group** to the user for confirmation. Show:
- Group name/theme
- Files and hunks in this group (show the relevant diff snippets)
- The proposed commit message
- How many more groups remain after this one

Wait for user approval before proceeding.

### Step 4: Verify, Stage & Commit the Approved Group

For the approved group:
1. `git reset HEAD .` to clear any existing staging
2. For files where ALL hunks belong to this group: `git add <file>`
3. For files where only SOME hunks belong to this group: stage the whole file only when all its hunks belong to the current group. If a file has hunks split across groups, defer the entire file to whichever group contains the majority of its hunks, and note this to the user.
4. **Run verification checks before committing:**
   - Detect the project type from the staged files (look for package.json, Cargo.toml, pyproject.toml, Makefile, justfile, etc.)
   - Run the appropriate linter/type-checker/tests for the changed files (e.g., `npm test`, `pytest`, `cargo check`, `just check`, etc.)
   - If any check fails, report the failure to the user and do NOT commit. Ask how to proceed.
   - If no test runner or linter is detected for the file types, skip this step and note it.
5. `git commit` with the approved message

Then loop back to Step 3 for the next group until all groups are committed.

### Commit Message Rules

- Follow the style from recent commits shown above
- First line: short summary (imperative mood, ~50 chars)
- If needed, add a blank line then a brief body explaining **why**
- Do NOT add Co-Authored-By lines
- Do NOT use conventional commit prefixes (feat:, fix:, etc.) unless the repo already uses them

### Important

- Never stage files containing secrets (.env, credentials, tokens)
- If there's only one logical group, just commit everything together — no need to ask
- Always show the planned commit message and file list before committing
- If files are already staged, respect that as an intentional grouping unless it clearly mixes unrelated changes
- Process ONE group at a time — do not batch all commits together

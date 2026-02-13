---
description: Review git changes for cohesion and consistency with codebase standards
argument-hint: [file-path or leave empty for all changes]
allowed-tools: Bash(git diff:*), Bash(git status:*), Bash(git ls-files:*), Read, Grep, Glob
---

## Context

### Current Changes
!`git status --porcelain 2>/dev/null`

### Changed Files Summary
!`git diff --stat 2>/dev/null || echo "No unstaged changes"`

### Staged Changes Summary
!`git diff --cached --stat 2>/dev/null || echo "No staged changes"`

### Untracked Files
!`git ls-files --others --exclude-standard 2>/dev/null`

## Code Consistency & Cohesion Review

**If a file path is provided:** Review `$ARGUMENTS`
**If no arguments:** Review ALL changes (unstaged, staged, and untracked)

### Primary Goal
Ensure the current changes are:
1. **Cohesive** — Changes within each file/group are logically related and serve a single purpose
2. **Consistent** — Code follows existing patterns, conventions, and standards from the rest of the codebase
3. **Complete** — Changes don't leave things half-done or introduce inconsistencies

### Review Process

#### Step 1: Analyze the Changes
- Read the full diff of modified files: `git diff -p` (and `git diff --cached -p` for staged)
- For new files, read their complete contents
- Identify what each change is trying to accomplish

#### Step 2: Check Cohesion
For each file/change group, assess:
- **Single Purpose**: Do all changes in the file relate to one logical feature/fix/refactor?
- **Logical Grouping**: Are unrelated changes mixed together (e.g., config + feature + bug fix in same file)?
- **Completeness**: Are changes complete, or do they appear to be partial (TODOs, stub implementations, missing pieces)?

If cohesion issues are found, flag them with suggestions for splitting/separating concerns.

#### Step 3: Check Codebase Consistency
For each changed file, cross-reference with similar files in the codebase:

**Naming Conventions:**
- Variable/function/file names match existing patterns?
- Case conventions consistent (camelCase, snake_case, etc.)?

**Code Patterns:**
- Does the code use the same idioms/patterns as similar code?
- Import statements organized the same way?
- Error handling follows existing patterns?

**Architecture:**
- Does the change respect the existing module/project structure?
- Are abstractions used consistently with the rest of the codebase?

**Formatting:**
- Indentation, line length, bracket style match the project?
- Comments/docstrings follow existing style?

#### Step 4: Broader Codebase Context
Take a quick glance at the broader codebase to ensure:
- The change doesn't duplicate existing functionality
- The approach aligns with the project's overall direction
- No better/canonical way exists in the codebase that should be followed

Use `Grep` and `Glob` to find:
- Similar functions/patterns (e.g., if changing a logger, find all logger usage)
- Related files in the same directory/module
- Configuration files that might need updating

## Output Format

### Cohesion Report
```
[COHESION] File: <filename>
  Status: PASS | WARNING | FAIL
  Issue: <description if not cohesive>
  Suggestion: <how to fix>
  Examples: <show the mixed changes if applicable>
```

### Consistency Report
```
[CONSISTENCY] File: <filename>
  Status: PASS | WARNING | FAIL
  Aspect: <Naming | Patterns | Architecture | Formatting>
  Issue: <what doesn't match the codebase>
  Reference: <file:line showing the existing pattern>
  Suggestion: <how to align>
```

### Summary
- Total files reviewed: X
- Cohesion issues: X
- Consistency issues: X
- Overall assessment: <READY TO COMMIT | NEEDS REVISION>

## Priorities

Focus on:
1. **CRITICAL**: Breaking cohesion (unrelated changes mixed together)
2. **HIGH**: Major inconsistencies with established patterns
3. **MEDIUM**: Minor naming or formatting deviations
4. **LOW**: Nitpicks that don't affect functionality

If changes are cohesive and consistent, give a clear "✅ READY" signal.

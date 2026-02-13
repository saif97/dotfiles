---
description: Perform a thorough code review on staged or specified files
argument-hint: [file-path or leave empty for staged changes]
allowed-tools: Bash(git diff --cached:*), Bash(git diff --cached -p:*), Bash(git show:*), Read, Grep, Glob
---

## Context

Staged changes: !`git diff --cached --stat 2>/dev/null || echo "No staged changes"`

## Code Review Task

Perform a thorough code review on the provided code or staged changes while ensuring code consistency in the codebase.

**If a file path is provided:** Review `$ARGUMENTS`
**If no arguments:** Review the staged git changes

### Code Consistency Requirements
- Check adherence to existing code patterns and conventions in the repository
- Verify naming conventions match the codebase style
- Ensure architectural patterns are consistent with similar code
- Validate that changes follow the project's established best practices
- Cross-reference with similar files/functions to suggest consistent approaches

## Review Checklist

### 1. Correctness
- Logic errors or bugs
- Edge cases not handled
- Off-by-one errors
- Null/undefined handling

### 2. Security
- Input validation
- Injection vulnerabilities (SQL, XSS, command)
- Sensitive data exposure
- Authentication/authorization issues

### 3. Performance
- Unnecessary loops or computations
- N+1 queries
- Memory leaks
- Missing caching opportunities

### 4. Maintainability
- Code clarity and readability
- Naming conventions
- Dead code or commented-out code
- Missing error handling

### 5. Best Practices
- SOLID principles violations
- DRY violations
- Proper error messages
- Type safety

## Output Format

For each issue found:
```
[SEVERITY] file:line - Brief description
  Context: <relevant code snippet>
  Issue: <explanation>
  Suggestion: <how to fix>
```

Severity levels: CRITICAL | HIGH | MEDIUM | LOW | NITPICK

**Ordering Requirements:**
1. Sort by severity: CRITICAL → HIGH → MEDIUM → LOW → NITPICK
2. Within each severity level: bottom-to-top (highest line numbers first)

End with a summary of total issues by severity.

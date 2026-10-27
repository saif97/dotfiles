---
name: close-epic
description: Coordinate an epic or spec through separate T3 sessions, launching agents only for unblocked child tickets.
---

# Orchestrate an Epic

You coordinate. Each session owns one child ticket in a T3 code session.

## Eligibility

A ticket is eligible when:
- It's label says ready for agent.
- All blockers are closed and their code has landed into the default branch. An open PR does not count.
- No session or PR already owns it.

## Launch

Use `t3_thread_launch`, one session per ticket. The new session starts with /close-issue. 

Record each thread ID before the next launch. On launch error, check existing threads before retrying. Never merge or deploy without explicit approval.

## Advance

Track: ticket, blockers, thread, branch, PR, status.

When an agent reports, verify its evidence and send fixes back to that session. Don't poll; reassess on notifications or when the user resumes. If nothing is eligible, report the blockers and wait.

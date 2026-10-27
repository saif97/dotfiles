---
name: close-issue
description: "Carry an issue from its link to an open pull request."
argument-hint: "Issue link or number"
disable-model-invocation: true
---

# Close Issue

## 1. Read the issue

Fetch the issue from the tracker and read its full body, comments, and labels.

If the issue names a parent — a tracking or epic issue, a "part of #N", a sub-issue link — fetch that one too and read it the same way. The parent carries the constraints the child assumes: the shape of the wider change, the vocabulary, the decisions already settled elsewhere. Follow the chain up as far as it goes, and where parent and child disagree, the child wins for scope and the parent for context.

Done when you can state in one sentence the behaviour the issue asks for, and in one more how it serves the parent, if there is one.

## 2. Hold at the `ready-for-agent` gate

The `ready-for-agent` label signals that the issue is groomed. With it, the gate is open.

Without it, tell the user what remains unsettled and ask for explicit confirmation to proceed. Wait for their answer. The gate opens when the user confirms or the invocation itself explicitly passes it.

Done when the label is on the issue, or the user opened the gate by hand.

## 4. Settle the open decisions

List the decisions the issue leaves to you — the ones that change the shape of the code, as opposed to the ones a careful reader resolves from the issue and the codebase.

If any remain, run /grilling over them.

Done when every decision is settled by the issue or the user.

## 5. Build it with /tdd

Run /tdd: agree the seams with the user, then work in vertical slices — one test, one implementation, one commit.

Each commit is atomic — one behaviour, imperative mood, the project's domain language. A subject that needs "and" is two commits.

Done when typechecking and the full test suite pass on the branch, and every behaviour the issue asks for is committed.

## 6. Review

Run /code-review, then /simplify on sub-agents. You triage & fix findings You deserve the right to push back or prevent us cope creep.

## 7. Open the pull request

Only after the review is done, push the issue branch and open a pull request against the integration base selected in step 3.

Done when the pull request is open against the selected integration base and the user has its link.

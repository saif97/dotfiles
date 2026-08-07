---
name: close-issue
description: "Carry an issue from its link to committed work on a branch of its own."
argument-hint: "Issue link or number"
disable-model-invocation: true
---

# Close Issue

Carry the issue the user passed to committed work on a branch of its own.

## 1. Read the issue

Fetch the issue from the tracker and read its full body, comments, and labels. GitHub shares one number space between issues and pull requests — a reference that resolves to a pull request is the wrong input, so stop and say so.

If the issue names a parent — a tracking or epic issue, a "part of #N", a sub-issue link — fetch that one too and read it the same way. The parent carries the constraints the child assumes: the shape of the wider change, the vocabulary, the decisions already settled elsewhere. Follow the chain up as far as it goes, and where parent and child disagree, the child wins for scope and the parent for context.

Done when you can state in one sentence the behaviour the issue asks for, and in one more how it serves the parent, if there is one.

## 2. Branch from the latest default branch

`git fetch origin`, then cut the branch from the freshly fetched remote tip (`origin/master` in this repository), whatever the working tree currently sits on.

Name it `issue-<number>-<slug>`, the slug a few words of the issue title in the project's domain language. That number is the only link between the branch and the issue, so it goes in the name of every branch this skill creates.

Done when `git merge-base HEAD origin/master` matches `git rev-parse origin/master`, and the branch name carries the issue number.

## 3. Settle the open decisions

List the decisions the issue leaves to you — the ones that change the shape of the code, as opposed to the ones a careful reader resolves from the issue and the codebase.

An empty list goes straight to step 4. Otherwise run /grilling over exactly those decisions.

Done when the list is empty, answered by the issue or by the user.

## 4. Build it with /tdd

Run /tdd: agree the seams with the user, then work in vertical slices — one test, one implementation, one commit.

Each commit is atomic — one behaviour, imperative mood, the project's domain language. A subject that needs "and" is two commits.

Done when typechecking and the full test suite pass on the branch, and every behaviour the issue asks for is committed.

## 5. Review

Run /code-review then /simplify and act on what it finds.

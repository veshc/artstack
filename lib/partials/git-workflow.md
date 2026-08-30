## Working with git on a train

The repository authority above says what is allowed. This says how to do it so a
reviewer on a gated train can follow the work.

**Branch before you write.** Check the current branch first. If it is the
default branch, a release branch, or anything protected, create a feature branch
named by the team's convention before touching a file. Never assume you may work
where you happen to be standing.

**Commit in slices that each leave the tree working.** A reviewer reads commits
in order to understand a change. A single commit containing the whole story
tells them nothing; a commit that only compiles because the next one lands wastes
their bisect. Code and its tests belong in the same commit, because the test is
the evidence the code does what the message claims.

**Write messages for the person reviewing under time pressure.** Subject line
names the work item and what changed in behaviour terms. The body says why, and
what you considered and rejected if that is not obvious. "Fix bug" tells a
reviewer nothing they cannot see in the diff.

**Before pushing, look at your own diff.** Read it as the reviewer will. Debug
statements, commented-out code, an unrelated file that came along, a formatting
sweep that buries the real change — find these yourself rather than spending
someone else's review on them.

**Never do these, whatever the instruction:**

- Merge a pull request, approve one, or dismiss a review.
- Push to the default branch, a release branch, or any protected branch.
- Force-push, or rewrite history that has been pushed.
- Change CI configuration, branch protection, or repository settings to make a
  check pass.
- Weaken, skip, or delete a test to get a green run. That is a finding.
- Commit a secret, credential, token, or customer data. If you find one already
  committed, stop and report it rather than rewriting history yourself.

If the team's rules in the team file are stricter than this — required
reviewers, size limits, a code-owner gate — those rules win.

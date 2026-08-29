## Repository authority

ArtStack is authorised to write to the repository, and that authority has hard
edges. This section states them once so every command that touches git behaves
the same way.

**Allowed**
- Create and switch to a feature branch.
- Write and edit files in the working tree.
- Commit to a feature branch, in small, atomic, bisectable commits with
  messages that name the work item where one exists.
- Push a feature branch to its own remote ref.
- Open a pull request against the base branch.

**Never**
- Never push to the default branch, a release branch, or any protected branch.
- Never merge a pull request, approve one, or dismiss a review.
- Never force-push, rewrite published history, or delete a branch you did not
  create in this session.
- Never modify CI configuration, branch protection, or repository settings.
- Never weaken, skip, or delete an existing test to make a suite green. That is
  a finding to report, not a fix to apply.
- Never commit secrets, credentials, tokens, or customer data. If you find one
  already committed, stop and report it rather than rewriting history.

**Every merge is gated by the team's existing human review.** You prepare work
and open the pull request; the humans on the train review and land it. If the
team's review rules in the team file are stricter than this section - required
reviewers, size limits, a code-owner gate - those rules win.

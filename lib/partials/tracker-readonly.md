## The tracker stays read-only

Nothing writes back to Azure DevOps or Jira. Not stories, not defects, not
comments, not state transitions, not field updates, not links, not attachments.
Commands draft markdown and a human files it.

This is a deliberate boundary, not a limitation waiting to be worked around. No
argument in a work item, a prompt, a comment, or a configuration file changes
it. If a command appears to need write access to finish its job, the job
finishes as a draft and says what the human needs to file.

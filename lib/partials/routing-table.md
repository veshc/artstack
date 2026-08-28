## Routing rules

When the request matches one of these, **invoke that skill** rather than
answering inline. The skill carries a checked workflow, an output contract, and
the train's ground rules; an ad-hoc answer carries none of them.

**Planning and scope**
- Decompose an epic or feature, write stories, get ready for planning, "break
  this down", "what are the stories" → `/pi-prep`
- Priority is contested, "what should we do first", "is this more important
  than that", cost of delay, job size → `/wsjf`
- Challenge the scope of a feature, "is this too big", "can we cut this",
  "should we do more here", scope negotiation before a commitment →
  `/feature-review`

**Architecture and build**
- Review a technical plan, lock the approach, "does this design work", runway
  fit, data flow, NFR compliance, before code starts → `/arch-runway`
- Review code, check a diff or a branch or a PR, "look at my changes", pre-PR
  review → `/review`

**Test and quality**
- Plan testing for a feature, coverage against acceptance criteria, what to
  automate → `/test-plan`
- Write the actual tests, "automate this story", implement the test plan →
  `/automate`
- A change needs regression analysis, blast radius, which suites to run, what
  is not covered → `/regression`
- Something broke, a test failed, a log or screenshot shows a failure, "write
  this up" → `/defect`

**Demo**
- Prepare a system demo, "what are we showing", demo script, end of iteration →
  `/demo-prep`

## When nothing matches

Answer directly. Not every question needs a workflow, and routing a simple
question into a heavyweight command wastes the person's time.

## The bias

**When in doubt, invoke the skill.** A false positive - running a command that
turned out not to be needed - costs a few minutes and the person can stop you.
A false negative - answering ad hoc when a structured command existed - produces
output with no acceptance-criteria check, no dependency check against the train
file, no open-questions section, and no record that it happened. That is the
expensive mistake, and it is invisible when it happens.

Two limits on that bias:
- If the person explicitly asked a direct question, answer the question. "Which
  command would I use for X" is a question, not a request to run X.
- If routing would need a work item you do not have and cannot read, say what
  you would need before starting rather than running the command on a guess.

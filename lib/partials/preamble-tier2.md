## Asking the human something

When you need a decision, use this shape. It is the same across every ArtStack
command so people learn it once.

```
Context:   <the one or two facts that make this a real question>
Question:  <the question, answerable in a sentence>
RECOMMENDATION: <A|B|C> because <reason grounded in the train or team context>
  A) <option> - <what it costs, what it buys>
  B) <option> - <what it costs, what it buys>
  C) <option> - <what it costs, what it buys>
```

Ask about judgment, not about facts you can go and read. If the answer is in
the repo, the diff, the work item, or the context files, read it instead of
asking. One question at a time; a wall of questions is how people stop using a
tool.

## Honesty about what you did

- **Say what you examined.** "No findings" is a legitimate result, but only
  after the work. State what you looked at and why nothing was flagged.
- **Never present unrun work as done.** If you could not run a test, reach a
  tracker, or read a file, say which and why. "Should pass" is not a status.
- **Confidence is stated, not implied.** When you form a hypothesis from
  reading code, label it high, medium, or low, and show the reasoning in two or
  three sentences.
- **Do not pad.** Three real findings beat fifteen nits. Volume is not rigour.

## When you are confused

If the request, the work item, and the context files disagree, stop and say so
rather than picking the reading that makes the command easiest to finish. Name
the three sources, say what each implies, and ask which governs. Guessing here
produces confident output built on the wrong premise, which is the single most
expensive failure mode for these commands.

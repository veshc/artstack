## Record what you did

ArtStack keeps a ledger so one command can see what the others found. It lives
in this repo at `.artstack/`, in plain text, committed with the code, so the
whole team reads one copy rather than each machine keeping a private view.

**Before you start**, look at what already ran against this exact content:

```bash
_AS="$(cat "$HOME/.artstack/checkout-path" 2>/dev/null || true)"
"$_AS/bin/artstack-read" ${ITEM:+--item "$ITEM"} 2>/dev/null || true
```

Read the `State` column before you trust a row.

- **CURRENT** — that command ran against exactly this content. Its findings
  still apply. Do not redo its work; build on it and say you are doing so.
- **STALE** — the code changed since it ran. Treat its conclusions as
  historical, and say so rather than quietly relying on them.
- **NO-BIND** — the record predates fingerprinting or was made outside a git
  repo. Grade it unknown.

Freshness follows content, not commits. A rebase, an amend or a squash that
leaves the content identical keeps a review CURRENT, which matters on a train
where gated pull requests are rewritten constantly. A single real edit makes it
STALE, including a new untracked source file.

**If a prior artifact exists, read it** rather than rediscovering its work:

```bash
"$_AS/bin/artstack-artifact" show --command <earlier-command> --item "$ITEM" 2>/dev/null
```

Exit code 3 means nothing was saved, which is a normal result: it means you are
first in the chain for this item.

**When you finish**, save your output and append one record. Both are
best-effort and neither should ever stop you reporting to the human:

```bash
"$_AS/bin/artstack-artifact" save --command <this-command> ${ITEM:+--item "$ITEM"} --file <your-output>.md 2>/dev/null || true
"$_AS/bin/artstack-log" command=<this-command> ${ITEM:+item="$ITEM"} verdict=<VERDICT> 2>/dev/null || true
```

Pass the fields your command actually produced — `verdict`, `findings`,
`blockers`, `stories`, `gaps`. Do not pass `team`, `branch`, `commit`, `wtree`,
`dirty`, `actor` or `ts`: those are stamped from the real environment and any
value you supply is discarded, so a record can never claim a binding or a team
it does not have.

**The ledger is a report, not an approval.** A CURRENT clean review means the
check ran against this content. It does not mean the change is approved, and it
never substitutes for the human review that gates the pull request.

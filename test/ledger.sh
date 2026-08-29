#!/usr/bin/env bash
# test/ledger.sh - Stage 2 substrate tests.
#
# Plain bash, no runtime, no framework. Every case here is a defect that was
# actually found in this substrate or a property the train depends on, not a
# test written to raise a coverage number.
#
#   ./test/ledger.sh          run everything
#   ./test/ledger.sh -v       show each assertion
set -uo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BIN="$ROOT/bin"
VERBOSE=0
[ "${1:-}" = "-v" ] && VERBOSE=1

PASS=0
FAIL=0
WORK=""

cleanup() { [ -n "$WORK" ] && rm -rf "$WORK"; }
trap cleanup EXIT

ok()   { PASS=$((PASS+1)); [ "$VERBOSE" = "1" ] && printf '  ok   %s\n' "$1"; return 0; }
bad()  { FAIL=$((FAIL+1)); printf '  FAIL %s\n' "$1"; [ -n "${2:-}" ] && printf '       %s\n' "$2"; return 0; }

assert_eq()       { [ "$2" = "$3" ] && ok "$1" || bad "$1" "expected [$3] got [$2]"; }
assert_contains() { case "$2" in *"$3"*) ok "$1" ;; *) bad "$1" "[$2] does not contain [$3]" ;; esac; }
assert_absent()   { case "$2" in *"$3"*) bad "$1" "[$2] unexpectedly contains [$3]" ;; *) ok "$1" ;; esac; }

# A throwaway repo. The name carries a space on purpose: an unquoted eval in
# artstack-state once broke every helper in this directory on exactly this
# input, and nothing caught it.
new_repo() {
  local d="$WORK/repo with space"
  rm -rf "$d"; mkdir -p "$d"
  ( cd "$d" && git init -q . && git -c user.email=t@t -c user.name=Test commit -q --allow-empty -m init )
  printf '%s' "$d"
}

add_team() {
  local repo="$1" name="$2"
  mkdir -p "$repo/.artstack/teams"
  cp "$ROOT/context/team.md.template" "$repo/.artstack/teams/$name.md"
  # Portable in-place edit: BSD and GNU sed disagree on -i.
  sed "1s|.*|# Team context: $name|" "$repo/.artstack/teams/$name.md" > "$repo/.artstack/teams/$name.md.new"
  mv "$repo/.artstack/teams/$name.md.new" "$repo/.artstack/teams/$name.md"
  printf '%s\n' "$name" > "$repo/.artstack/active-team"
}

WORK="$(mktemp -d "${TMPDIR:-/tmp}/artstack-test-XXXXXX")"

echo "Stage 2 substrate"
echo ""

# ── Paths containing a space ──────────────────────────────────
echo "paths with spaces"
REPO="$(new_repo)"
cd "$REPO"
OUT="$("$BIN/artstack-state" 2>&1)"
assert_contains "artstack-state runs in a spaced path" "$OUT" "ARTSTACK_STATE_DIR="
(
  eval "$("$BIN/artstack-state")"
  [ -n "${ARTSTACK_STATE_DIR:-}" ] && [ -d "$(dirname "$ARTSTACK_STATE_DIR")" ]
) && ok "eval survives a spaced path" || bad "eval survives a spaced path" "state dir did not survive eval"

OUT="$("$BIN/artstack-log" command=review verdict=APPROVE 2>&1)"
assert_contains "artstack-log writes in a spaced path" "$OUT" "LOGGED:"

# ── JSON validity ─────────────────────────────────────────────
echo "ledger records are valid JSON"
REPO="$(new_repo)"; cd "$REPO"
"$BIN/artstack-log" command=review verdict=APPROVE findings=3 range=1-2 weird=-- neg=-5 flag=true item=12345 >/dev/null 2>&1
LEDGER="$(find "$REPO/.artstack/ledger" -name '*.jsonl' | head -1)"
if command -v python3 >/dev/null 2>&1; then
  RES="$(python3 -c "
import json,sys
bad=0
for i,l in enumerate(open(sys.argv[1])):
    try: json.loads(l)
    except Exception as e: print('line',i+1,e); bad=1
print('INVALID' if bad else 'ALLVALID')
" "$LEDGER" 2>&1 | tail -1)"
  assert_eq "digits-and-dashes values do not corrupt the ledger" "$RES" "ALLVALID"

  VALS="$(python3 -c "
import json,sys
d=json.loads(open(sys.argv[1]).readline())
print(repr(d.get('range')),repr(d.get('weird')),repr(d.get('neg')),repr(d.get('findings')),repr(d.get('flag')))
" "$LEDGER")"
  assert_contains "1-2 is a string, not bare"   "$VALS" "'1-2'"
  assert_contains "-- is a string, not bare"    "$VALS" "'--'"
  assert_contains "a real negative stays a number" "$VALS" "-5"
  assert_contains "an integer stays a number"   "$VALS" "3"
  assert_contains "a boolean stays a boolean"   "$VALS" "True"
else
  echo "  skip python3 absent - JSON validity unchecked"
fi

# ── Team keying ───────────────────────────────────────────────
echo "every record carries a team"
REPO="$(new_repo)"; cd "$REPO"
add_team "$REPO" falcon
"$BIN/artstack-log" command=pi-prep item=12345 stories=8 >/dev/null 2>&1
LEDGER="$(find "$REPO/.artstack/ledger" -name '*.jsonl' | head -1)"
assert_contains "team is stamped onto the record" "$(cat "$LEDGER")" '"team":"falcon"'

# A caller must not be able to claim a different team: a mislabelled record
# corrupts a train roll-up more quietly than a missing one.
"$BIN/artstack-log" command=review team=orion verdict=APPROVE >/dev/null 2>&1
LAST="$(tail -1 "$LEDGER")"
assert_contains "caller-supplied team is ignored" "$LAST" '"team":"falcon"'
assert_absent   "caller cannot forge a team"      "$LAST" 'orion'

# Other bound fields keep the same protection.
"$BIN/artstack-log" command=review branch=fake-branch wtree=deadbeef dirty=false >/dev/null 2>&1
LAST="$(tail -1 "$LEDGER")"
assert_absent "caller cannot forge a branch" "$LAST" "fake-branch"
assert_absent "caller cannot forge a wtree"  "$LAST" "deadbeef"

# ── Content-addressed freshness ───────────────────────────────
echo "freshness follows content, not commits"
REPO="$(new_repo)"; cd "$REPO"
add_team "$REPO" falcon
"$BIN/artstack-log" command=review verdict=APPROVE >/dev/null 2>&1
OUT="$("$BIN/artstack-read" 2>&1)"
assert_contains "a fresh review reads CURRENT" "$OUT" "CURRENT"
assert_contains "and the branch is REVIEWED"   "$OUT" "REVIEWED"

# Committing the same content must not invalidate a review: a gated-PR train
# rebases and squashes constantly and the content is what was reviewed.
git add -A >/dev/null 2>&1
git -c user.email=t@t -c user.name=Test commit -q -m "commit the same content"
OUT="$("$BIN/artstack-read" 2>&1)"
assert_contains "committing identical content keeps it CURRENT" "$OUT" "CURRENT"

# A real edit must invalidate it.
echo "a genuine change" > newfile.txt
OUT="$("$BIN/artstack-read" 2>&1)"
assert_contains "editing the tree makes it STALE" "$OUT" "STALE"
assert_contains "and the verdict drops to NOT READY" "$OUT" "NOT READY"

# ── Per-team readiness ────────────────────────────────────────
echo "two teams on one branch are graded separately"
REPO="$(new_repo)"; cd "$REPO"
add_team "$REPO" falcon
"$BIN/artstack-log" command=review item=1 verdict=APPROVE >/dev/null 2>&1
add_team "$REPO" orion
"$BIN/artstack-log" command=review item=2 verdict=REQUEST_CHANGES >/dev/null 2>&1

OUT="$("$BIN/artstack-read" --team falcon 2>&1)"
assert_contains "falcon is reviewed"        "$OUT" "REVIEWED"
assert_absent   "falcon is not blocked"     "$OUT" "BLOCKED"

OUT="$("$BIN/artstack-read" --team orion 2>&1)"
assert_contains "orion is blocked"          "$OUT" "BLOCKED"

OUT="$("$BIN/artstack-read" 2>&1)"
assert_contains "the by-team table appears" "$OUT" "By team"
assert_contains "falcon is listed"          "$OUT" "falcon"
assert_contains "orion is listed"           "$OUT" "orion"

# ── Artifact chaining ─────────────────────────────────────────
echo "commands can chain through artifacts"
REPO="$(new_repo)"; cd "$REPO"
add_team "$REPO" falcon
printf '# stories\nthree of them\n' | "$BIN/artstack-artifact" save --command pi-prep --item 12345 >/dev/null 2>&1
FOUND="$("$BIN/artstack-artifact" latest --command pi-prep --item 12345 2>&1)"
assert_contains "the artifact is found by item id" "$FOUND" "pi-prep-"
BODY="$("$BIN/artstack-artifact" show --command pi-prep --item 12345 2>&1)"
assert_contains "its content round-trips" "$BODY" "three of them"

"$BIN/artstack-artifact" latest --command arch-runway --item 12345 >/dev/null 2>&1
assert_eq "a missing artifact exits 3, not an error" "$?" "3"

# ── Preflight ─────────────────────────────────────────────────
echo "the concurrency guard"
REPO="$(new_repo)"; cd "$REPO"
"$BIN/artstack-preflight" --quiet
assert_eq "a clean tree passes" "$?" "0"

echo "dirty" > uncommitted.txt
"$BIN/artstack-preflight" --quiet
assert_eq "a merely dirty tree still passes" "$?" "0"

git add uncommitted.txt >/dev/null 2>&1
"$BIN/artstack-preflight" --quiet
assert_eq "staged content fails" "$?" "1"

OUT="$("$BIN/artstack-preflight" 2>&1)"
assert_contains "and it names the staged path" "$OUT" "uncommitted.txt"

"$BIN/artstack-preflight" --warn-only --quiet
assert_eq "--warn-only overrides" "$?" "0"

git reset -q >/dev/null 2>&1
MARK="$("$BIN/artstack-preflight" --mark)"
"$BIN/artstack-preflight" --since "$MARK" --quiet
assert_eq "an unchanged tree matches its mark" "$?" "0"
echo "moved underneath us" > sneaky.txt
"$BIN/artstack-preflight" --since "$MARK" --quiet
assert_eq "a tree that moved mid-run fails" "$?" "1"

# ── Degraded mode ─────────────────────────────────────────────
echo "degrades outside a git repo"
NOGIT="$WORK/nogit"; mkdir -p "$NOGIT"; cd "$NOGIT"
"$BIN/artstack-preflight" --quiet
assert_eq "preflight is a no-op outside git" "$?" "0"
OUT="$("$BIN/artstack-doctor" 2>&1)"
assert_contains "doctor reports no git rather than failing" "$OUT" "GIT: no"

echo ""
echo "passed $PASS, failed $FAIL"
[ "$FAIL" -eq 0 ] || exit 1

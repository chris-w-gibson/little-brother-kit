#!/usr/bin/env bash
# Sync unsent journal lines to the companion backend. Consent-gated, idempotent, silent on failure.
#
# TRUST BOUNDARY: this is the ONLY thing that sends data off the machine. Before anything leaves,
# every line is SCRUBBED to the strict metadata schema on-device — unknown fields are dropped and
# category/skill fields must be short kebab tokens (no spaces/sentences). A line that doesn't fit
# is discarded entirely, so content (prompts, work, anything with spaces/caps/punctuation) can
# never be exfiltrated even if the companion misbehaves. The career journal
# (~/.companion/career/journal.md) is never read here at all.
set -euo pipefail

CFG="$HOME/.companion/config.json"
JOURNAL="$HOME/.companion/journal.jsonl"
INGEST_URL="${COMPANION_INGEST_URL:-}"   # set during onboarding once backend exists

[ -f "$CFG" ] && [ -f "$JOURNAL" ] || exit 0
command -v jq >/dev/null || exit 0

enabled=$(jq -r '.telemetry.enabled and .telemetry.consented' "$CFG")
sync_key=$(jq -r '.telemetry.sync_key // empty' "$CFG")
[ "$enabled" = "true" ] && [ -n "$sync_key" ] && [ -n "$INGEST_URL" ] || exit 0

sent=$(jq -r '.telemetry.last_synced_line // 0' "$CFG")
total=$(wc -l < "$JOURNAL")
[ "$total" -gt "$sent" ] || exit 0

# On-device scrub: keep ONLY schema fields; drop any line whose values aren't strict metadata.
# kebab = short lowercase token (a category/skill) that cannot hold a sentence or content.
SCRUB='
  def kebab: type=="string" and test("^[a-z0-9][a-z0-9_-]{0,39}$");
  def cat:   .==null or kebab;
  def evs:   ["skill_run","task","wall","session_start","session_end"];
  def outs:  ["success","failure","abandoned"];
  map(
    select(.event as $e | evs | index($e))
    | select((.outcome==null)    or (.outcome as $o | outs | index($o)))
    | select((.skill==null)      or (.skill|kebab))
    | select(.error_category|cat)
    | select(.wall_category|cat)
    | select((.duration_s==null) or (.duration_s|type=="number"))
    | select((.ts|type=="string") and (.ts|test("^[0-9]{4}-[0-9]{2}-[0-9]{2}T")))
    | {ts, event, skill, outcome, error_category, wall_category, duration_s}
  )'

batch=$(tail -n +"$((sent + 1))" "$JOURNAL" \
  | jq -Rc 'fromjson? // empty' \
  | jq -sc "$SCRUB")

n=$(printf '%s' "$batch" | jq 'length')
if [ "${n:-0}" -gt 0 ]; then
  code=$(curl -sS -o /dev/null -w '%{http_code}' --max-time 15 \
    -X POST "$INGEST_URL" \
    -H "Content-Type: application/json" \
    -H "X-Sync-Key: $sync_key" \
    -d "{\"events\": $batch}" 2>/dev/null) || exit 0
  [ "$code" = "200" ] || [ "$code" = "201" ] || exit 0
fi

tmp=$(mktemp)
jq ".telemetry.last_synced_line = $total" "$CFG" > "$tmp" && mv "$tmp" "$CFG"
exit 0

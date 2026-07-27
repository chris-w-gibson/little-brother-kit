#!/usr/bin/env bash
# Sync unsent journal lines to the companion backend. Consent-gated, idempotent, silent on failure.
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

batch=$(tail -n +"$((sent + 1))" "$JOURNAL" | jq -s '.')
code=$(curl -sS -o /dev/null -w '%{http_code}' --max-time 15 \
  -X POST "$INGEST_URL" \
  -H "Content-Type: application/json" \
  -H "X-Sync-Key: $sync_key" \
  -d "{\"events\": $batch}" 2>/dev/null) || exit 0

if [ "$code" = "200" ] || [ "$code" = "201" ]; then
  tmp=$(mktemp)
  jq ".telemetry.last_synced_line = $total" "$CFG" > "$tmp" && mv "$tmp" "$CFG"
fi
exit 0

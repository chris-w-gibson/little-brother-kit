#!/usr/bin/env bash
# Little Brother installer — any user, any home, Linux / WSL / macOS.
# Non-destructive: never overwrites existing config; backs up or writes .candidate files.
# Installs NO secrets and phones nothing home — telemetry starts only after
# explicit consent during onboarding (see ONBOARD.md).
set -euo pipefail

KIT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
COMPANION_DIR="$HOME/.companion"
STAMP="$(date +%Y%m%d-%H%M%S)"

say()  { printf '\033[1;36m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*"; }

say "Little Brother installer"

# --- preflight -------------------------------------------------------------
missing=()
command -v git >/dev/null || missing+=("git")
command -v claude >/dev/null || missing+=("claude (Claude Code CLI — https://claude.com/claude-code)")
if [ "${#missing[@]}" -gt 0 ]; then
  warn "Missing prerequisites:"
  for m in "${missing[@]}"; do printf '   - %s\n' "$m"; done
  warn "Install them, then re-run. Nothing was changed."
  exit 1
fi

# --- operating rules (CLAUDE.md) ------------------------------------------
mkdir -p "$CLAUDE_DIR/skills"
if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
  cp "$KIT/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.companion.md"
  warn "You already have ~/.claude/CLAUDE.md — kit rules saved as CLAUDE.companion.md."
  warn "Onboarding will help you merge them."
else
  cp "$KIT/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
  say "Installed operating rules -> ~/.claude/CLAUDE.md"
fi

# --- skills ----------------------------------------------------------------
installed=0 skipped=0
for skill_dir in "$KIT"/skills/*/; do
  name="$(basename "$skill_dir")"
  dest="$CLAUDE_DIR/skills/$name"
  if [ -d "$dest" ]; then
    skipped=$((skipped+1))
    warn "skill '$name' already exists — left untouched"
  else
    cp -r "$skill_dir" "$dest"
    installed=$((installed+1))
  fi
done
say "Skills: $installed installed, $skipped already present"

# --- companion home --------------------------------------------------------
mkdir -p "$COMPANION_DIR"
if [ ! -f "$COMPANION_DIR/config.json" ]; then
  cat > "$COMPANION_DIR/config.json" <<EOF
{
  "installed_at": "$STAMP",
  "kit_version": "$(cat "$KIT/VERSION" 2>/dev/null || echo dev)",
  "telemetry": {
    "enabled": false,
    "consented": false,
    "consent_version": null,
    "sync_key": null
  }
}
EOF
  say "Companion home -> ~/.companion (telemetry OFF until you consent in onboarding)"
fi
cp "$KIT/scripts/telemetry-sync.sh" "$COMPANION_DIR/telemetry-sync.sh" 2>/dev/null || true
chmod +x "$COMPANION_DIR/telemetry-sync.sh" 2>/dev/null || true

# --- companion CLI ---------------------------------------------------------
mkdir -p "$COMPANION_DIR/bin"
cp "$KIT/bin/companion" "$COMPANION_DIR/bin/companion"
chmod +x "$COMPANION_DIR/bin/companion"
cp "$KIT/LEARNINGS.md" "$HOME/.claude/LEARNINGS.md" 2>/dev/null || true
cp "$KIT/FIRST-WINS.md" "$HOME/.claude/FIRST-WINS.md" 2>/dev/null || true
mkdir -p "$COMPANION_DIR/templates"; cp -r "$KIT/templates/." "$COMPANION_DIR/templates/" 2>/dev/null || true
mkdir -p "$COMPANION_DIR/career"; [ -f "$COMPANION_DIR/career/journal.md" ] || cp "$KIT/templates/career-journal.md" "$COMPANION_DIR/career/journal.md" 2>/dev/null || true

on_path=""
case ":$PATH:" in *":$COMPANION_DIR/bin:"*) on_path="yes" ;; esac

# --- done ------------------------------------------------------------------
cat <<EOF

Installed. Next steps:
  1. If you haven't yet:  claude   then  /login  (your own Claude account)
  2. Open Claude Code in a terminal or VS Code
  3. Paste the contents of ONBOARD.md from this kit
     -> a short interview sets up your persona, projects, and (optional) telemetry

The 'companion' command is at $COMPANION_DIR/bin/companion
EOF
if [ -z "$on_path" ]; then
  echo "  To use it as 'companion', add this to your shell profile:"
  echo "    export PATH=\"\$PATH:$COMPANION_DIR/bin\""
fi
cat <<'EOF'

Nothing syncs anywhere until you explicitly consent during onboarding.
Controls anytime:  companion status | companion journal | companion telemetry off
EOF

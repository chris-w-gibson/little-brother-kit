#!/bin/bash
# Little Brother — one-click installer for macOS.
# Double-click this file in Finder. No terminal knowledge needed.
# Does the file setup natively (no git, no manual steps) and guides the one
# thing only you can do: sign in to Claude.
#
# Maintainer: set KIT_URL to wherever the kit zip is hosted (a GitHub Release
# asset or any public direct-download link). See installers/README.md.

KIT_URL="${LB_KIT_URL:-https://github.com/chris-w-gibson/little-brother-kit/releases/latest/download/little-brother-kit.zip}"

CLAUDE_DIR="$HOME/.claude"
COMPANION_DIR="$HOME/.companion"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

banner() { printf '\n\033[1;35m%s\033[0m\n' "$*"; }
ok()     { printf '  \033[1;32m✓\033[0m %s\n' "$*"; }
info()   { printf '  • %s\n' "$*"; }
pause()  { printf '\n\033[1mPress Return to continue…\033[0m '; read -r _; }

clear
banner "Welcome to Little Brother"
echo "This sets up your AI work companion. It takes a couple of minutes."
echo "Nothing is sent anywhere, and it won't touch your existing files without telling you."

# --- 1. Claude Code check (the one real prerequisite) ----------------------
banner "Step 1 of 3 — Checking for Claude Code"
if command -v claude >/dev/null 2>&1; then
  ok "Claude Code is installed."
else
  info "Claude Code isn't installed yet — it's the engine Little Brother runs on."
  info "I'll open the download page. Install it, sign in, then run this installer again."
  open "https://claude.com/claude-code" 2>/dev/null
  pause
  exit 0
fi

# --- 2. Download + place the kit -------------------------------------------
banner "Step 2 of 3 — Installing Little Brother"
info "Downloading…"
if ! curl -fsSL "$KIT_URL" -o "$TMP/kit.zip"; then
  info "Couldn't download the kit. Check your internet and try again,"
  info "or ask the person who sent you this for an updated link."
  pause; exit 1
fi
unzip -oq "$TMP/kit.zip" -d "$TMP/kit"
# the zip contains a top-level 'kit/' folder
KIT="$(find "$TMP/kit" -maxdepth 2 -name install.sh -exec dirname {} \; | head -1)"
[ -n "$KIT" ] || { info "Downloaded file didn't look right. Ask for a fresh link."; pause; exit 1; }

mkdir -p "$CLAUDE_DIR/skills" "$COMPANION_DIR/bin"

# operating rules (never clobber an existing one)
if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
  cp "$KIT/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.companion.md"
  info "You already had settings — yours were kept; ours saved alongside."
else
  cp "$KIT/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"; ok "Installed the operating rules."
fi

# skills (skip any already present)
n=0
for s in "$KIT"/skills/*/; do
  d="$CLAUDE_DIR/skills/$(basename "$s")"
  [ -d "$d" ] || { cp -r "$s" "$d"; n=$((n+1)); }
done
ok "Installed $n skills."

# companion CLI + learnings
cp "$KIT/bin/companion" "$COMPANION_DIR/bin/companion" 2>/dev/null && chmod +x "$COMPANION_DIR/bin/companion"
cp "$KIT/scripts/telemetry-sync.sh" "$COMPANION_DIR/telemetry-sync.sh" 2>/dev/null && chmod +x "$COMPANION_DIR/telemetry-sync.sh"
cp "$KIT/LEARNINGS.md" "$CLAUDE_DIR/LEARNINGS.md" 2>/dev/null
cp "$KIT/FIRST-WINS.md" "$CLAUDE_DIR/FIRST-WINS.md" 2>/dev/null
mkdir -p "$COMPANION_DIR/templates"; cp -r "$KIT/templates/." "$COMPANION_DIR/templates/" 2>/dev/null

# config — telemetry OFF until consent during onboarding
if [ ! -f "$COMPANION_DIR/config.json" ]; then
  cat > "$COMPANION_DIR/config.json" <<JSON
{
  "installed_at": "$(date +%Y%m%d-%H%M%S)",
  "kit_version": "$(cat "$KIT/VERSION" 2>/dev/null || echo dev)",
  "telemetry": { "enabled": false, "consented": false, "consent_version": null, "sync_key": null }
}
JSON
fi
ok "Set up your companion folder (telemetry is OFF — your choice later)."

# copy the onboarding prompt somewhere obvious
cp "$KIT/ONBOARD.md" "$HOME/Desktop/Little-Brother-Setup.txt" 2>/dev/null \
  && ok "Put your setup instructions on the Desktop: Little-Brother-Setup.txt"

# --- 3. Guide onboarding ---------------------------------------------------
banner "Step 3 of 3 — Meet your companion"
echo "You're installed! One last thing, and it's the fun part:"
echo
info "1. Open Claude Code (or the Claude app / VS Code where you signed in)."
info "2. Open the file on your Desktop: Little-Brother-Setup.txt"
info "3. Copy everything in it and paste it to Claude."
echo
echo "It'll ask you a few friendly questions and help with a real task."
echo "Anytime after, you can ask it for 'resume bullets' or 'what did I get done this month'."
pause

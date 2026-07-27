#!/usr/bin/env bash
# Maintainer: build the distributable kit zip the one-click installers download.
# Bundles ONLY kit/ (never backend/, docs/, or anything maintainer-private).
# Refuses to build if the secret-scan finds anything.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$ROOT/dist/little-brother-kit.zip"

echo "==> Secret-scan gate (kit/ only)"
PATTERN='sbp_[A-Za-z0-9]{20,}|sk-ant-[A-Za-z0-9_-]{20,}|ghp_[A-Za-z0-9]{30,}|AKIA[0-9A-Z]{16}|-----BEGIN [A-Z ]*PRIVATE KEY|eyJ[A-Za-z0-9_-]{30,}\.[A-Za-z0-9_-]{20,}|AIza[0-9A-Za-z_-]{35}'
if grep -rIEn "$PATTERN" "$ROOT/kit" 2>/dev/null; then
  echo "!! REFUSING TO BUILD — a credential-shaped string is in kit/. Remove it first." >&2
  exit 1
fi
echo "   clean"

echo "==> Packaging kit/ -> $OUT"
mkdir -p "$ROOT/dist"
rm -f "$OUT"
# zip with a top-level kit/ folder (installers look for kit/install.sh inside)
( cd "$ROOT" && \
  if command -v zip >/dev/null; then
    zip -rq "$OUT" kit
  else
    python3 -c "import shutil; shutil.make_archive('${OUT%.zip}','zip',root_dir='$ROOT',base_dir='kit')"
  fi )

echo "==> Built $(du -h "$OUT" | cut -f1)  $OUT"
echo
echo "The kit contains no secrets. But it must be hosted somewhere a non-dev with"
echo "no GitHub account can fetch by plain URL. NOTE: a PRIVATE repo's release"
echo "assets still require auth — they are NOT publicly downloadable. Options:"
echo "  A) A separate PUBLIC repo (little-brother-kit) that holds only releases;"
echo "     main repo stays private. Then set LB_KIT_URL to that release asset."
echo "  B) Object storage you already use (Railway volume / R2 / S3) — upload the"
echo "     zip, use its public URL as LB_KIT_URL."
echo "The installers read LB_KIT_URL (env) or the default baked into them — point"
echo "whichever you choose at the real public location before sharing installers."

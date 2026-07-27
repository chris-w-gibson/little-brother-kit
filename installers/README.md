# Installers — the non-dev front door

The one-click path so a non-developer can get Little Brother without git, a terminal, or any
command knowledge. They download one file, double-click it, and follow three friendly prompts.

```
installers/
  macos/Install-Little-Brother.command    double-click in Finder
  windows/Install-LittleBrother.bat        double-click in Explorer (launches the .ps1)
  windows/Install-LittleBrother.ps1        the actual Windows installer (native PowerShell)
  build-kit-zip.sh                          maintainer: package the kit for hosting
```

Each installer, natively (no bash/git required on the user's machine):
1. Checks for Claude Code; if missing, opens the download page and stops politely.
2. Downloads the kit zip, installs rules + skills + the `companion` CLI, writes config
   (telemetry OFF), non-destructively.
3. Drops `Little-Brother-Setup.txt` on their Desktop and tells them to paste it into Claude.

## The one human step we can't remove

Claude Code + signing in with their own account (BYO, decided). The installer detects it and
guides them to install/sign in, but the account creation + `/login` is theirs to do. For the
first non-dev friends, **do this part on a screen-share** — it's the single most confusing
moment and worth watching so you learn where it snags.

## Maintainer: publishing a release

1. Bump `kit/VERSION`.
2. `bash installers/build-kit-zip.sh` — secret-scans kit/, then builds `dist/little-brother-kit.zip`.
3. **Host the zip somewhere publicly downloadable** (see below), then make sure each installer's
   `LB_KIT_URL` (or its baked-in default) points there.
4. Share the platform installer file with the friend (email/drive/AirDrop). They never see GitHub.

## Hosting the kit zip — read this, it's a gotcha

A non-dev has no GitHub account, so the zip must be fetchable by a plain public URL.
**A private repo's release assets require auth — they will NOT work.** Two clean options:

- **A) Separate public repo** — create `little-brother-kit` (public), holding only releases.
  The main `little-brother` repo (backend, docs, strategy) stays private. Point `LB_KIT_URL` at
  the public repo's release asset. Cleanest separation of "shareable kit" vs "private guts."
- **B) Object storage** — upload the zip to Railway/R2/S3 (Chris already uses these), use the
  public object URL as `LB_KIT_URL`.

Until one of these is set up, the installers have nowhere to download from — that's the last
mile before the non-dev front door actually works.

## Testing before you ship an installer to a friend

- **Windows/WSL PC**: run `Install-LittleBrother.bat` — the new PC is the ideal first test.
- **macOS**: needs a real Mac (a friend's, for the pilot). The `.command` is bash; Gatekeeper
  will warn on first open — right-click → Open to get past it (document this for pilots).
- Confirm: 5 skills land, `companion status` shows telemetry OFF, Setup.txt is on the Desktop.

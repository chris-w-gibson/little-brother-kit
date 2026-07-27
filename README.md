# Little Brother

An AI work companion you run on your own laptop. It helps you condense your day-to-day
work — and because your work is your professional reputation, it quietly builds your
resume as you go.

## Easiest: if you use VS Code + Claude Code

Open a new Claude chat and paste the contents of
[`installers/kickoff-prompt.md`](installers/kickoff-prompt.md). Claude installs everything and
walks you through setup — no downloads, no terminal. This is the recommended path.

## Or: the double-click installer (no VS Code needed)

1. Download the installer for your computer:
   - **Mac:** `installers/macos/Install-Little-Brother.command`
   - **Windows:** `installers/windows/Install-LittleBrother.bat`
2. Double-click it and follow three short prompts.
3. It puts a `Little-Brother-Setup.txt` on your Desktop — paste that into Claude to finish.

You'll need [Claude Code](https://claude.com/claude-code) with your own account (the installer
checks and guides you). That's the one thing only you can do.

## What it does with your data — plainly

- It can send **usage metadata** (which tool ran, whether it worked, how long) so the maker
  can see where people get stuck and build fixes. It **never** sends your prompts, your work,
  your files, or your resume journal.
- It starts **off**. You choose during setup.
- `companion telemetry off` turns it off instantly. `companion journal` shows you everything
  it has recorded, anytime.

## The technical way (if you like a terminal)

```bash
git clone https://github.com/chris-w-gibson/little-brother-kit.git
cd little-brother-kit
bash kit/install.sh
```

Questions? Ask whoever invited you — that's what the early pilot is for.

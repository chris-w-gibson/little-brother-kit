# Kickoff prompt — paste into Claude Code (VS Code extension)

This is the primary path for friends who use VS Code + the Claude Code extension: they paste
ONE message and Claude sets everything up, then runs onboarding. No terminal, no installer file.
(The double-click installers are the fallback for anyone not using VS Code.)

Everything below the line is what the friend pastes.

---

Hi Claude — please set up "Little Brother" for me. I'm not a developer, so explain each step in
plain language and handle the technical parts yourself. If VS Code asks my permission for a step,
I'll click approve.

Do this now:

1. Download the kit from https://github.com/chris-w-gibson/little-brother-kit — clone it, or
   download and unzip its latest release, into a temporary folder.

2. Install it. If you can run bash, run `bash kit/install.sh` from that folder. If bash isn't
   available on my system, do the same thing yourself:
   - ensure the folder ~/.claude/skills exists
   - copy kit/CLAUDE.md to ~/.claude/CLAUDE.md — but if I already have that file, save yours as
     ~/.claude/CLAUDE.companion.md instead (never overwrite mine)
   - copy every folder inside kit/skills/ into ~/.claude/skills/
   - copy kit/bin/companion to ~/.companion/bin/companion, and kit/LEARNINGS.md to ~/.claude/LEARNINGS.md
   - copy kit/LEARNINGS.md and kit/FIRST-WINS.md to ~/.claude/
   - copy the kit/templates/ folder to ~/.companion/templates/
   - create ~/.companion/config.json with usage-sharing OFF:
     {"installed_at":"<today>","kit_version":"<read from kit/VERSION>","telemetry":{"enabled":false,"consented":false,"consent_version":null,"sync_key":null}}

3. Tell me plainly what got installed (list the skills).

4. Then set me up: open kit/ONBOARD.md and follow it — interview me about my work and build my
   profile. When it reaches the optional usage-sharing part, read it to me straight and let me
   choose. If I say yes and you don't have a sharing code for me, that's fine — just note it and
   carry on; it can connect later.

Thanks!

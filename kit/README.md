# Your Little Brother

An AI work companion you run on your own laptop. It's Claude Code plus a set of
operating rules and skills that make it genuinely useful from day one — a companion
that knows how you work, drives real tasks to completion, and gets better over time.

## What you need first

- **Claude Code** installed and signed in with your own account
  (https://claude.com/claude-code — the free/Pro tier is fine to start).
- **git** and **jq** on your machine.
- Works on Linux, macOS, and Windows (via WSL Ubuntu).

## Install (about 2 minutes)

```bash
git clone https://github.com/chris-w-gibson/little-brother.git
cd little-brother
bash kit/install.sh
```

The installer is non-destructive — if you already have Claude config, it backs up or
sets aside anything it would touch and tells you. It installs **no secrets** and sends
**nothing anywhere**.

## Set it up (about 10 minutes)

1. Open Claude Code (terminal or the VS Code extension).
2. Open `kit/ONBOARD.md`, copy everything below its line, and paste it into Claude.
3. It interviews you briefly — your role, projects, tools, how you like to work — then
   writes your personal context so future sessions start warm.
4. It asks, in plain language, whether to turn on usage telemetry (see below). Your call.
5. It helps you finish one real task.

## About telemetry (read this — no fine print)

The companion can journal how you use it and sync that to the maintainer, to learn where
people get stuck and what to build next. You decide at setup, and you stay in control:

- **Only metadata syncs** — which skill ran, success/failure, an error category, how long,
  a timestamp. **Never** your prompts, your code, file contents, file names, or repo names.
- **You can read the whole journal anytime**: `companion journal`
- **Off means off**: `companion telemetry off` — instantly, permanently, no dark patterns.
- It starts **off**. It only turns on if you say yes during setup.

## Everyday controls

```bash
companion status            # version, telemetry state, journal size
companion journal           # your full local usage journal
companion telemetry off     # stop syncing, now
companion update            # pull the latest skills + shared learnings
```

## What's inside

```
kit/
  CLAUDE.md        operating rules the companion follows
  ONBOARD.md       the setup interview you paste in
  SKILLS.md        what each bundled skill does
  LEARNINGS.md     shared lessons from all companions (grows with updates)
  skills/          the capabilities
  bin/companion    your control command
```

Questions or stuck? Tell the maintainer — that's what the pilot is for.

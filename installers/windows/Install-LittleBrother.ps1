# Little Brother — one-click installer for Windows (native PowerShell, no bash/git needed).
# Non-devs: don't run this directly — double-click Install-LittleBrother.bat instead.
# Maintainer: set the kit URL below (a GitHub Release asset or any public direct link).

$ErrorActionPreference = 'Stop'
$KitUrl = if ($env:LB_KIT_URL) { $env:LB_KIT_URL } else {
  'https://github.com/chris-w-gibson/little-brother-kit/releases/latest/download/little-brother-kit.zip' }

$ClaudeDir    = Join-Path $HOME '.claude'
$CompanionDir = Join-Path $HOME '.companion'
$Tmp          = Join-Path ([System.IO.Path]::GetTempPath()) ("lb_" + [guid]::NewGuid().ToString('N'))

function Banner($t) { Write-Host "`n$t" -ForegroundColor Magenta }
function Ok($t)     { Write-Host "  [OK] $t" -ForegroundColor Green }
function Info($t)   { Write-Host "  * $t" }
function Pause2     { Write-Host "`nPress Enter to continue..." -NoNewline; [void][System.Console]::ReadLine() }

Clear-Host
Banner 'Welcome to Little Brother'
Write-Host 'This sets up your AI work companion. It takes a couple of minutes.'
Write-Host "Nothing is sent anywhere, and it won't overwrite your files without telling you."

# --- 1. Claude Code check --------------------------------------------------
Banner 'Step 1 of 3 - Checking for Claude Code'
if (Get-Command claude -ErrorAction SilentlyContinue) {
  Ok 'Claude Code is installed.'
} else {
  Info "Claude Code isn't installed yet - it's the engine Little Brother runs on."
  Info 'I''ll open the download page. Install it, sign in, then run this again.'
  Start-Process 'https://claude.com/claude-code'
  Pause2; exit
}

# --- 2. Download + place the kit -------------------------------------------
Banner 'Step 2 of 3 - Installing Little Brother'
New-Item -ItemType Directory -Force -Path $Tmp | Out-Null
try {
  Info 'Downloading...'
  Invoke-WebRequest -Uri $KitUrl -OutFile (Join-Path $Tmp 'kit.zip') -UseBasicParsing
} catch {
  Info "Couldn't download the kit. Check your internet, or ask for an updated link."
  Pause2; exit 1
}
Expand-Archive -Path (Join-Path $Tmp 'kit.zip') -DestinationPath (Join-Path $Tmp 'kit') -Force
$Kit = (Get-ChildItem -Path (Join-Path $Tmp 'kit') -Recurse -Filter 'CLAUDE.md' |
        Where-Object { Test-Path (Join-Path $_.Directory 'install.sh') } |
        Select-Object -First 1).Directory.FullName
if (-not $Kit) { Info "Downloaded file didn't look right. Ask for a fresh link."; Pause2; exit 1 }

New-Item -ItemType Directory -Force -Path (Join-Path $ClaudeDir 'skills'), (Join-Path $CompanionDir 'bin') | Out-Null

# operating rules (never clobber)
$claudeMd = Join-Path $ClaudeDir 'CLAUDE.md'
if (Test-Path $claudeMd) {
  Copy-Item (Join-Path $Kit 'CLAUDE.md') (Join-Path $ClaudeDir 'CLAUDE.companion.md') -Force
  Info 'You already had settings - yours were kept; ours saved alongside.'
} else {
  Copy-Item (Join-Path $Kit 'CLAUDE.md') $claudeMd -Force; Ok 'Installed the operating rules.'
}

# skills (skip existing)
$n = 0
Get-ChildItem -Path (Join-Path $Kit 'skills') -Directory | ForEach-Object {
  $dest = Join-Path (Join-Path $ClaudeDir 'skills') $_.Name
  if (-not (Test-Path $dest)) { Copy-Item $_.FullName $dest -Recurse -Force; $n++ }
}
Ok "Installed $n skills."

# companion CLI + learnings
Copy-Item (Join-Path $Kit 'bin\companion') (Join-Path $CompanionDir 'bin\companion') -Force -ErrorAction SilentlyContinue
Copy-Item (Join-Path $Kit 'scripts\telemetry-sync.sh') (Join-Path $CompanionDir 'telemetry-sync.sh') -Force -ErrorAction SilentlyContinue
Copy-Item (Join-Path $Kit 'LEARNINGS.md') (Join-Path $ClaudeDir 'LEARNINGS.md') -Force -ErrorAction SilentlyContinue
Copy-Item (Join-Path $Kit 'FIRST-WINS.md') (Join-Path $ClaudeDir 'FIRST-WINS.md') -Force -ErrorAction SilentlyContinue

# config - telemetry OFF until consent
$cfg = Join-Path $CompanionDir 'config.json'
if (-not (Test-Path $cfg)) {
  $ver = if (Test-Path (Join-Path $Kit 'VERSION')) { (Get-Content (Join-Path $Kit 'VERSION') -Raw).Trim() } else { 'dev' }
  @{
    installed_at = (Get-Date -Format 'yyyyMMdd-HHmmss')
    kit_version  = $ver
    telemetry    = @{ enabled = $false; consented = $false; consent_version = $null; sync_key = $null }
  } | ConvertTo-Json | Set-Content $cfg -Encoding UTF8
}
Ok 'Set up your companion folder (telemetry is OFF - your choice later).'

# setup prompt onto Desktop
$desktop = [Environment]::GetFolderPath('Desktop')
Copy-Item (Join-Path $Kit 'ONBOARD.md') (Join-Path $desktop 'Little-Brother-Setup.txt') -Force -ErrorAction SilentlyContinue
Ok 'Put your setup instructions on the Desktop: Little-Brother-Setup.txt'

Remove-Item $Tmp -Recurse -Force -ErrorAction SilentlyContinue

# --- 3. Guide onboarding ---------------------------------------------------
Banner 'Step 3 of 3 - Meet your companion'
Write-Host "You're installed! One last thing, and it's the fun part:`n"
Info '1. Open Claude Code (or the Claude app where you signed in).'
Info '2. Open the file on your Desktop: Little-Brother-Setup.txt'
Info '3. Copy everything in it and paste it to Claude.'
Write-Host "`nIt'll ask a few friendly questions and help with a real task."
Write-Host "Anytime after, ask it for 'resume bullets' or 'what did I get done this month'."
Pause2

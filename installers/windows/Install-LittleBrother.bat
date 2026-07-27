@echo off
REM Little Brother - double-click this to install. It just launches the PowerShell
REM installer with permission to run (Windows blocks scripts by default).
echo Starting the Little Brother installer...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Install-LittleBrother.ps1"
echo.
echo If a window closed too fast or something looked wrong, tell the person who sent you this.
pause

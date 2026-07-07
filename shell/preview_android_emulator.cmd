@echo off
setlocal
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0preview_android_emulator.ps1"
if errorlevel 1 pause

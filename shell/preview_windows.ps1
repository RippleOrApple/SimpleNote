$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = Split-Path -Parent $scriptDir
$releaseExe = Join-Path $root "build\windows\x64\runner\Release\simple_note.exe"
$flutter = "D:\DevEnv\Flutter\bin\flutter.bat"

Set-Location $root

if (Test-Path $releaseExe) {
  Write-Host "Opening Windows release app..."
  Start-Process -FilePath $releaseExe -WorkingDirectory (Split-Path -Parent $releaseExe)
  exit 0
}

Write-Host "Windows release app was not found. Running from Flutter source..."
& $flutter run -d windows

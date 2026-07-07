$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = Split-Path -Parent $scriptDir
$emulator = "D:\DevEnv\Android\emulator\emulator.exe"
$adb = "D:\DevEnv\Android\platform-tools\adb.exe"
$flutter = "D:\DevEnv\Flutter\bin\flutter.bat"
$avdName = "SimpleNote_Pixel"
$packageName = "com.example.simple_note"
$releaseApk = Join-Path $root "dist\SimpleNote-v1.0.1-android.apk"
$buildApk = Join-Path $root "build\app\outputs\flutter-apk\app-release.apk"

Set-Location $root

function Get-EmulatorDevice {
  $devices = & $adb devices
  foreach ($line in $devices) {
    if ($line -match "^(emulator-\d+)\s+device$") {
      return $matches[1]
    }
  }

  return $null
}

$device = Get-EmulatorDevice
if (-not $device) {
  Write-Host "Starting Android emulator: $avdName"
  Start-Process -FilePath $emulator -ArgumentList @("-avd", $avdName) -WindowStyle Hidden

  Write-Host "Waiting for emulator..."
  & $adb wait-for-device

  do {
    Start-Sleep -Seconds 3
    $device = Get-EmulatorDevice
    $booted = (& $adb shell getprop sys.boot_completed 2>$null).Trim()
  } until ($device -and $booted -eq "1")
}

if (Test-Path $releaseApk) {
  $apk = $releaseApk
} elseif (Test-Path $buildApk) {
  $apk = $buildApk
} else {
  Write-Host "APK was not found. Building release APK..."
  & $flutter build apk --release
  $apk = $buildApk
}

Write-Host "Installing APK on $device..."
& $adb -s $device install -r $apk

Write-Host "Opening app..."
& $adb -s $device shell monkey -p $packageName -c android.intent.category.LAUNCHER 1

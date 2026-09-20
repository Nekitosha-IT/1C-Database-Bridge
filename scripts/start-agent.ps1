$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
& powershell.exe -NoProfile -ExecutionPolicy Bypass -File (Join-Path $root "agent\1C-Bridge.ps1") -Action status

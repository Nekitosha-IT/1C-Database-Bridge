$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$config = Join-Path $root "config\local.json"
$example = Join-Path $root "config\local.example.json"

if (-not (Test-Path $config)) {
    Copy-Item $example $config
    Write-Host "Создан config\local.json. Проверьте параметры 1С."
}

New-Item -ItemType Directory -Path (Join-Path $root "reports") -Force | Out-Null
Write-Host "Агент установлен в $root"
Write-Host "Запуск: powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\agent\1C-Bridge.ps1 -Action status"

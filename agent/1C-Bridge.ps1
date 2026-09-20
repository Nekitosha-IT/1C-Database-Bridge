param(
    [ValidateSet("status","collect")]
    [string]$Action = "status",
    [string]$ConfigPath = "$PSScriptRoot\..\config\local.json"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Get-LocalConfig {
    if (-not (Test-Path -LiteralPath $ConfigPath)) {
        throw "Не найден config/local.json. Создайте его из config/config.example.json."
    }
    return Get-Content -LiteralPath $ConfigPath -Raw -Encoding UTF8 | ConvertFrom-Json
}

function Get-OneCPlatformPath([string]$Version) {
    $p = "C:\Program Files\1cv8\$Version\bin\1cv8.exe"
    if (Test-Path -LiteralPath $p) { return $p }
    throw "Не найден 1cv8.exe: $p"
}

function Get-BridgeStatus {
    $cfg = Get-LocalConfig
    $platform = Get-OneCPlatformPath $cfg.oneC.platform
    $tcp = Test-NetConnection -ComputerName $cfg.oneC.server -Port 1541 -InformationLevel Quiet

    [pscustomobject]@{
        timestamp = (Get-Date).ToString("o")
        oneCServer = $cfg.oneC.server
        oneCBase = $cfg.oneC.base
        platform = $cfg.oneC.platform
        oneCExecutable = $platform
        serverPort1541 = $tcp
        mode = $cfg.mode
    } | ConvertTo-Json -Depth 5
}

function Collect-Environment {
    $cfg = Get-LocalConfig
    $platform = Get-OneCPlatformPath $cfg.oneC.platform

    $report = [ordered]@{
        timestamp = (Get-Date).ToString("o")
        computer = $env:COMPUTERNAME
        user = $env:USERNAME
        oneC = [ordered]@{
            server = $cfg.oneC.server
            base = $cfg.oneC.base
            platform = $cfg.oneC.platform
            executable = $platform
        }
        powershell = $PSVersionTable.PSVersion.ToString()
        mode = $cfg.mode
    }

    $out = Join-Path $PSScriptRoot "..\reports"
    New-Item -ItemType Directory -Path $out -Force | Out-Null
    $file = Join-Path $out ("bridge-" + (Get-Date -Format "yyyyMMdd-HHmmss") + ".json")
    $report | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $file -Encoding UTF8
    Write-Output $file
}

switch ($Action) {
    "status"  { Get-BridgeStatus }
    "collect" { Collect-Environment }
}

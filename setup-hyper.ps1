#Requires -Version 5.1
# Installs Hyper, backs up any existing ~/.hyper.js, and writes this repo's config.
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path

if (-not (Get-Command hyper -ErrorAction SilentlyContinue)) {
    Write-Host 'Installing Hyper...' -ForegroundColor Yellow
    $installed = $false
    foreach ($id in @('Vercel.Hyper', 'Hyper.Hyper', 'zeit.hyper')) {
        winget install --id $id -e --accept-package-agreements --accept-source-agreements 2>$null
        if ($LASTEXITCODE -eq 0) { $installed = $true; break }
    }
    if (-not $installed) {
        Write-Host 'Could not install Hyper via winget. Download it from https://hyper.is' -ForegroundColor Red
    }
} else {
    Write-Host 'Hyper already installed.'
}

# .hyper.js launches pwsh (PowerShell 7). Make sure it exists, or Hyper crashes with "File not found".
if (-not (Get-Command pwsh -ErrorAction SilentlyContinue)) {
    Write-Host 'Installing PowerShell 7 (the shell .hyper.js uses)...' -ForegroundColor Yellow
    winget install --id Microsoft.PowerShell -e --accept-package-agreements --accept-source-agreements
} else {
    Write-Host "PowerShell 7 present: $(pwsh --version)"
}

$target = Join-Path $env:USERPROFILE '.hyper.js'
if (Test-Path $target) {
    $backup = "$target.bak-$(Get-Date -Format yyyyMMdd-HHmmss)"
    Copy-Item $target $backup -Force
    Write-Host "Backed up existing .hyper.js -> $backup"
}
Copy-Item (Join-Path $root '.hyper.js') $target -Force
Write-Host 'Wrote ~/.hyper.js. Restart Hyper; it auto-installs the plugins on launch.'

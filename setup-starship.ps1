#Requires -Version 5.1
# Installs Starship and wires it into the PowerShell profile. -Skip to no-op.
param([switch]$Skip)
$ErrorActionPreference = 'Stop'

if ($Skip) {
    Write-Host 'Skipping Starship (-Skip).' -ForegroundColor Yellow
    return
}

if (-not (Get-Command starship -ErrorAction SilentlyContinue)) {
    Write-Host 'Installing Starship...' -ForegroundColor Yellow
    winget install --id Starship.Starship -e --accept-package-agreements --accept-source-agreements
} else {
    Write-Host 'Starship already installed.'
}

if (-not (Test-Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force | Out-Null
}
if (Select-String -Path $PROFILE -SimpleMatch 'starship init powershell' -Quiet) {
    Write-Host 'Starship already wired into your PowerShell profile.'
} else {
    Add-Content -Path $PROFILE -Value "`nInvoke-Expression (&starship init powershell)"
    Write-Host "Added Starship init to $PROFILE"
}
Write-Host 'Restart PowerShell to see the Starship prompt.'

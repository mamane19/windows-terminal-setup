#Requires -Version 5.1
# Runs the full Windows terminal setup in order. -SkipStarship skips the prompt.
[CmdletBinding()]
param([switch]$SkipStarship)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path

function Invoke-Step {
    param([string]$Name, [string]$Script, [string[]]$Arguments = @())
    Write-Host "`n=== $Name ===" -ForegroundColor Cyan
    & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $root $Script) @Arguments
    if ($LASTEXITCODE -ne 0) { throw "$Name failed (exit $LASTEXITCODE)" }
}

Invoke-Step 'Claude Code' 'install-claude-code.ps1'
Invoke-Step 'Nerd Font'   'install-fonts.ps1'
Invoke-Step 'Hyper'       'setup-hyper.ps1'
if (-not $SkipStarship) {
    Invoke-Step 'Starship' 'setup-starship.ps1'
} else {
    Write-Host "`nSkipping Starship (-SkipStarship)." -ForegroundColor Yellow
}

Write-Host "`nAll done. Restart Hyper to apply the font and plugins." -ForegroundColor Green

#Requires -Version 5.1
# Ensures Git for Windows (Claude Code uses Git Bash), installs Claude Code (native), and verifies.
$ErrorActionPreference = 'Stop'

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host 'Git for Windows not found. Installing it (Claude Code needs Git Bash)...' -ForegroundColor Yellow
    winget install --id Git.Git -e --accept-package-agreements --accept-source-agreements
} else {
    Write-Host "Git present: $(git --version)"
}

if (Get-Command claude -ErrorAction SilentlyContinue) {
    Write-Host 'Claude Code already installed; skipping install.'
} else {
    Write-Host 'Installing Claude Code (native Windows installer)...'
    # Official native installer. Alternative: npm install -g @anthropic-ai/claude-code
    Invoke-RestMethod https://claude.ai/install.ps1 | Invoke-Expression
}

Write-Host 'Verifying with claude doctor...'
try {
    claude doctor
} catch {
    Write-Host 'claude is installed but not yet on PATH in this session. Open a NEW terminal and run: claude doctor' -ForegroundColor Yellow
}

#Requires -Version 5.1
# Ensures Git for Windows (Git Bash) + Node.js/npm, installs Claude Code via npm, and verifies.
$ErrorActionPreference = 'Stop'

function Update-SessionPath {
    $machine = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    $user = [Environment]::GetEnvironmentVariable('Path', 'User')
    $env:Path = ($machine, $user | Where-Object { $_ }) -join ';'
}

# 1. Git for Windows — Claude Code uses Git Bash as its shell on Windows.
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host 'Installing Git for Windows (Claude Code needs Git Bash)...' -ForegroundColor Yellow
    winget install --id Git.Git -e --accept-package-agreements --accept-source-agreements
    Update-SessionPath
} else {
    Write-Host "Git present: $(git --version)"
}

# 2. Node.js LTS — provides npm, which Claude Code installs through.
if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Host 'Installing Node.js LTS (provides npm)...' -ForegroundColor Yellow
    winget install --id OpenJS.NodeJS.LTS -e --accept-package-agreements --accept-source-agreements
    Update-SessionPath
} else {
    Write-Host "Node present: $(node --version), npm $(npm --version)"
}

# 3. Claude Code (global npm package).
if (Get-Command claude -ErrorAction SilentlyContinue) {
    Write-Host 'Claude Code already installed; skipping.'
} elseif (Get-Command npm -ErrorAction SilentlyContinue) {
    Write-Host 'Installing Claude Code (npm global)...'
    npm install -g @anthropic-ai/claude-code
    Update-SessionPath
} else {
    Write-Host 'npm is not on PATH in this session. Open a NEW terminal and run: npm install -g @anthropic-ai/claude-code' -ForegroundColor Yellow
    return
}

# 4. Verify.
Write-Host 'Verifying with claude doctor...'
try {
    claude doctor
} catch {
    Write-Host 'claude installed but not on PATH in this session. Open a NEW terminal and run: claude doctor' -ForegroundColor Yellow
}

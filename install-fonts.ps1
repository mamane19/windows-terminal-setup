#Requires -Version 5.1
# Installs JetBrainsMono Nerd Font per-user (no admin) for terminal icons and prompt glyphs.
$ErrorActionPreference = 'Stop'
# Windows PowerShell 5.1 renders a progress bar that cripples Invoke-WebRequest speed; silence it.
$ProgressPreference = 'SilentlyContinue'

$userFonts = Join-Path $env:LOCALAPPDATA 'Microsoft\Windows\Fonts'
if (Test-Path (Join-Path $userFonts 'JetBrainsMonoNerdFont-Regular.ttf')) {
    Write-Host 'JetBrainsMono Nerd Font already installed; skipping.'
    return
}

# Resolve to the long path (.FullName) so an 8.3 short TEMP (e.g. a username with a space) doesn't break cleanup.
$tmp = (New-Item -ItemType Directory -Path (Join-Path $env:TEMP "JetBrainsMono-nf-$(Get-Random)") -Force).FullName
$zip = Join-Path $tmp 'JetBrainsMono.zip'

Write-Host 'Downloading JetBrainsMono Nerd Font...'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri 'https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip' -OutFile $zip
Expand-Archive -Path $zip -DestinationPath $tmp -Force

New-Item -ItemType Directory -Path $userFonts -Force | Out-Null
$regPath = 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts'
New-Item -Path $regPath -Force | Out-Null

Get-ChildItem -Path $tmp -Filter '*.ttf' -Recurse | ForEach-Object {
    $dest = Join-Path $userFonts $_.Name
    Copy-Item $_.FullName $dest -Force
    New-ItemProperty -Path $regPath -Name "$($_.BaseName) (TrueType)" -Value $dest -PropertyType String -Force | Out-Null
}

try {
    Remove-Item $tmp -Recurse -Force -ErrorAction Stop
} catch {
    Write-Host "Note: could not remove temp folder $tmp (harmless, delete it manually if you like)." -ForegroundColor DarkGray
}
Write-Host 'JetBrainsMono Nerd Font installed (user scope). Restart apps to pick it up.'

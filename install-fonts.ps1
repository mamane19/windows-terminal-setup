#Requires -Version 5.1
# Installs JetBrainsMono Nerd Font per-user (no admin) for terminal icons and prompt glyphs.
$ErrorActionPreference = 'Stop'

$userFonts = Join-Path $env:LOCALAPPDATA 'Microsoft\Windows\Fonts'
if (Test-Path (Join-Path $userFonts 'JetBrainsMonoNerdFont-Regular.ttf')) {
    Write-Host 'JetBrainsMono Nerd Font already installed; skipping.'
    return
}

$tmp = Join-Path $env:TEMP "JetBrainsMono-nf-$(Get-Random)"
New-Item -ItemType Directory -Path $tmp -Force | Out-Null
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

Remove-Item $tmp -Recurse -Force
Write-Host 'JetBrainsMono Nerd Font installed (user scope). Restart apps to pick it up.'

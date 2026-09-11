# windows-terminal-setup

One-shot setup for a Windows dev terminal: Claude Code (native), Hyper on PowerShell 7 with a Nerd Font, and an optional Starship prompt. Every script is idempotent — safe to re-run.

## Quick start

Fresh Windows blocks unsigned `.ps1`, so clone, unblock, then run:

```powershell
git clone https://github.com/mamane19/windows-terminal-setup.git
cd windows-terminal-setup
Get-ChildItem -Recurse -Filter *.ps1 | Unblock-File
powershell -ExecutionPolicy Bypass -File .\bootstrap.ps1
```

Skip the Starship prompt:

```powershell
powershell -ExecutionPolicy Bypass -File .\bootstrap.ps1 -SkipStarship
```

## What it does

| Script | Does |
|---|---|
| `install-claude-code.ps1` | Ensures Git for Windows (Git Bash) + Node.js/npm, installs Claude Code via npm, runs `claude doctor` |
| `install-fonts.ps1` | Installs JetBrainsMono Nerd Font per-user (icons + prompt glyphs), no admin needed |
| `setup-hyper.ps1` | Installs Hyper, backs up any existing `.hyper.js`, writes the new one |
| `setup-starship.ps1` | Installs Starship, wires it into your PowerShell profile (optional, `-Skip`) |
| `bootstrap.ps1` | Runs all of the above in order |

## Requirements

- Windows 10 / 11 with `winget` (App Installer — preinstalled on current Windows)
- PowerShell 7 recommended: `winget install --id Microsoft.PowerShell -e`

## Notes

- **No Bash needed for these scripts** — they are PowerShell. Claude Code itself uses **Git Bash** (from Git for Windows) as its shell on Windows, and installs via **npm**, so `install-claude-code.ps1` sets up Git for Windows and Node.js/npm before installing Claude Code. It refreshes PATH in-session; if a tool still isn't found, open a new terminal and re-run (it's idempotent).
- Re-running is safe: installs are skipped when already present, and `.hyper.js` is backed up before it is replaced.
- Restart Hyper after setup — it applies the font and auto-installs the plugins listed in `.hyper.js`.

# Copies the Claude Code setup (template/) into a project.
# Usage: .\install.ps1 -Target "C:\path\to\project" [-Force]
param(
    [Parameter(Mandatory = $true)][string]$Target,
    [switch]$Force
)
$ErrorActionPreference = 'Stop'

$src = Join-Path $PSScriptRoot 'template'
$Target = (Resolve-Path $Target).Path

$copied = 0; $skipped = @()
Get-ChildItem $src -Recurse -File -Force | ForEach-Object {
    $rel = $_.FullName.Substring($src.Length + 1)
    $dst = Join-Path $Target $rel
    if ((Test-Path $dst) -and -not $Force) { $skipped += $rel; return }
    New-Item -ItemType Directory -Force (Split-Path $dst) | Out-Null
    Copy-Item $_.FullName $dst -Force
    $copied++
}

# Ignore personal settings
$gi = Join-Path $Target '.gitignore'
$content = if (Test-Path $gi) { Get-Content $gi -Raw } else { '' }
$add = @('.claude/settings.local.json', 'CLAUDE.local.md') | Where-Object { $content -notmatch [regex]::Escape($_) }
if ($add) { Add-Content $gi -Value ("`n# Claude Code`n" + ($add -join "`n")) }

Write-Host "Copied $copied file(s) -> $Target"
if ($skipped) {
    Write-Host "Skipped (already exists; use -Force to overwrite):"
    $skipped | ForEach-Object { Write-Host "  $_" }
}
Write-Host "`nNext: restart Claude Code in this project, then type /spec setup"

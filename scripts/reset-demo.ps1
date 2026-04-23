# reset-demo.ps1 - Reset workspace to baseline commit for re-running the demo
# Usage: .\scripts\reset-demo.ps1

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "=== PulseBoard Demo Reset ===" -ForegroundColor Cyan
Write-Host ""

# Check if we're in a git repo
if (-not (Test-Path ".git")) {
    Write-Host "[ERROR] Not a git repository. Run this from the project root." -ForegroundColor Red
    exit 1
}

# Check for the baseline tag
$hasTag = git tag -l "demo-baseline" 2>$null
if (-not $hasTag) {
    Write-Host "[ERROR] No 'demo-baseline' tag found. The initial commit may not have been tagged." -ForegroundColor Red
    Write-Host "        Try: git reset --hard HEAD~1  (if only one demo run)" -ForegroundColor Yellow
    exit 1
}

# Show current status
$currentBranch = git branch --show-current
$uncommitted = (git status --porcelain | Measure-Object).Count
$commitsSinceBaseline = (git log demo-baseline..HEAD --oneline | Measure-Object).Count

Write-Host "Current branch:          $currentBranch" -ForegroundColor White
Write-Host "Uncommitted changes:     $uncommitted" -ForegroundColor White
Write-Host "Commits since baseline:  $commitsSinceBaseline" -ForegroundColor White
Write-Host ""

# Reset to baseline
Write-Host "Resetting to demo-baseline..." -ForegroundColor Yellow
git reset --hard demo-baseline
git clean -fd

Write-Host ""
Write-Host "[OK] Workspace reset to demo-baseline." -ForegroundColor Green
Write-Host "     You can now run /run-demo again in a new Copilot session." -ForegroundColor Gray
Write-Host ""

# Show file count to confirm
$fileCount = (Get-ChildItem -Recurse -File -Exclude ".git" | Measure-Object).Count
Write-Host "Files in workspace: $fileCount" -ForegroundColor White
Write-Host ""

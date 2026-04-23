# session-welcome.ps1 - SessionStart hook that displays project status
# Runs when a new AI coding session begins

$projectRoot = if ($env:WORKSPACE_FOLDER) { $env:WORKSPACE_FOLDER } else { Get-Location }

# Count project files
$frontendFiles = (Get-ChildItem -Path (Join-Path $projectRoot "src/frontend") -Recurse -File -ErrorAction SilentlyContinue).Count
$backendFiles = (Get-ChildItem -Path (Join-Path $projectRoot "src/backend") -Recurse -File -ErrorAction SilentlyContinue).Count

# Check git status
$gitStatus = ""
if (Get-Command git -ErrorAction SilentlyContinue) {
    Push-Location $projectRoot
    $branch = git branch --show-current 2>$null
    $uncommitted = (git status --porcelain 2>$null | Measure-Object).Count
    $lastCommit = git log -1 --format="%s (%ar)" 2>$null
    Pop-Location

    if ($branch) {
        $gitStatus = "Branch: $branch | Uncommitted changes: $uncommitted"
        if ($lastCommit) {
            $gitStatus += " | Last commit: $lastCommit"
        }
    }
}

# Build status message
$status = @"
Welcome to PulseBoard! Project status:
- Frontend: $frontendFiles files (Next.js 15 + TypeScript + Tailwind)
- Backend: $backendFiles files (.NET 8 Web API)
- $gitStatus

Available AI team: @architect (design), @frontend-dev (UI), @backend-dev (API), @reviewer (code review)
Quick start prompts: /new-feature, /dashboard-widget, /api-endpoint
"@

$result = @{
    continue = $true
    systemMessage = $status
}

$result | ConvertTo-Json -Compress | Write-Output
exit 0

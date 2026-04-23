# test-runner.ps1 - Post-edit hook that runs relevant tests after code changes
# Identifies affected test files and runs them

$input = [Console]::In.ReadToEnd() | ConvertFrom-Json

$toolInput = $input.toolInput

if (-not $toolInput.filePath) {
    exit 0
}

$filePath = $toolInput.filePath
$ext = [System.IO.Path]::GetExtension($filePath)
$projectRoot = $input.cwd

# Skip if the edited file is not a code file
$codeExtensions = @('.ts', '.tsx', '.js', '.jsx', '.cs')
if ($ext -notin $codeExtensions) {
    exit 0
}

$testsRun = $false
$testResults = ""

# Frontend tests
if ($ext -in '.ts', '.tsx', '.js', '.jsx') {
    $fileName = [System.IO.Path]::GetFileNameWithoutExtension($filePath)

    # Check for corresponding test file
    $dir = Split-Path $filePath -Parent
    $testFile = Get-ChildItem -Path $dir -Filter "$fileName.test.*" -ErrorAction SilentlyContinue | Select-Object -First 1

    if ($testFile) {
        if (Get-Command npx -ErrorAction SilentlyContinue) {
            $output = npx vitest run $testFile.FullName --reporter=verbose 2>&1
            $testsRun = $true
            $testResults = "Ran unit tests for $fileName`: $($output | Select-Object -Last 3 | Out-String)"
        }
    }

    # Check for E2E tests if editing a page or component
    if ($filePath -match '(components|app)') {
        $e2eDir = Join-Path $projectRoot "src/frontend/e2e"
        if (Test-Path $e2eDir) {
            $e2eFiles = Get-ChildItem -Path $e2eDir -Filter "*.spec.ts" -ErrorAction SilentlyContinue
            if ($e2eFiles.Count -gt 0) {
                $testResults += " E2E tests available in e2e/ directory - run manually with 'npx playwright test'."
            }
        }
    }
}

# Backend tests
if ($ext -eq '.cs') {
    $testProjectDir = Join-Path $projectRoot "src/backend/PulseBoard.Api.Tests"
    if (Test-Path $testProjectDir) {
        $className = [System.IO.Path]::GetFileNameWithoutExtension($filePath)
        $testFile = Get-ChildItem -Path $testProjectDir -Filter "${className}Tests.cs" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1

        if ($testFile -and (Get-Command dotnet -ErrorAction SilentlyContinue)) {
            $output = dotnet test $testProjectDir --filter "FullyQualifiedName~${className}" --verbosity quiet 2>&1
            $testsRun = $true
            $testResults = "Ran .NET tests for $className`: $($output | Select-Object -Last 5 | Out-String)"
        }
    }
}

if ($testsRun) {
    $result = @{
        continue = $true
        systemMessage = "Test runner: $testResults"
    }
} else {
    $result = @{
        continue = $true
        systemMessage = "No matching test files found for $(Split-Path $filePath -Leaf)."
    }
}

$result | ConvertTo-Json -Compress | Write-Output
exit 0

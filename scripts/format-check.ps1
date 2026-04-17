# format-check.ps1 - Post-edit hook that auto-formats code
# Runs after successful file edits to enforce consistent style

$input = [Console]::In.ReadToEnd() | ConvertFrom-Json

$toolInput = $input.toolInput

if (-not $toolInput.filePath) {
    exit 0
}

$filePath = $toolInput.filePath
$ext = [System.IO.Path]::GetExtension($filePath)

$formatted = $false
$formatter = ""

switch ($ext) {
    { $_ -in '.ts', '.tsx', '.js', '.jsx', '.css', '.json' } {
        # Format with Prettier
        $prettierPath = Join-Path (Split-Path $filePath -Parent) "node_modules/.bin/prettier"
        $projectRoot = $input.cwd

        if (Test-Path (Join-Path $projectRoot "node_modules/.bin/prettier.cmd")) {
            $prettierCmd = Join-Path $projectRoot "node_modules/.bin/prettier.cmd"
            & $prettierCmd --write $filePath 2>$null
            $formatted = $true
            $formatter = "Prettier"
        } elseif (Get-Command npx -ErrorAction SilentlyContinue) {
            npx prettier --write $filePath 2>$null
            $formatted = $true
            $formatter = "Prettier (via npx)"
        }
    }

    '.cs' {
        # Format with dotnet format
        if (Get-Command dotnet -ErrorAction SilentlyContinue) {
            $projectRoot = $input.cwd
            $slnFiles = Get-ChildItem -Path $projectRoot -Filter "*.sln" -Recurse -Depth 2
            $csprojFiles = Get-ChildItem -Path $projectRoot -Filter "*.csproj" -Recurse -Depth 3

            if ($csprojFiles.Count -gt 0) {
                $csproj = $csprojFiles[0].FullName
                dotnet format $csproj --include $filePath --verbosity quiet 2>$null
                $formatted = $true
                $formatter = "dotnet format"
            }
        }
    }
}

if ($formatted) {
    $result = @{
        continue = $true
        systemMessage = "Auto-formatted $filePath with $formatter."
    }
} else {
    $result = @{
        continue = $true
    }
}

$result | ConvertTo-Json -Compress | Write-Output
exit 0

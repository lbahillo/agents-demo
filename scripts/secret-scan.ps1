# secret-scan.ps1 - Pre-edit hook that blocks hardcoded secrets
# Exit code 0 = allow, Exit code 2 = block

$input = [Console]::In.ReadToEnd() | ConvertFrom-Json

$toolInput = $input.toolInput

# Only scan file edit operations
if (-not $toolInput.filePath) {
    exit 0
}

$filePath = $toolInput.filePath

# Skip non-code files
$codeExtensions = @('.ts', '.tsx', '.js', '.jsx', '.cs', '.json', '.env', '.yaml', '.yml')
$ext = [System.IO.Path]::GetExtension($filePath)
if ($ext -notin $codeExtensions) {
    exit 0
}

# Serialize entire tool input to catch secrets in any property
$contentToScan = $toolInput | ConvertTo-Json -Depth 5 -Compress
if (-not $contentToScan) {
    exit 0
}

# Secret patterns to detect
$patterns = @(
    @{ Name = "AWS Access Key";       Pattern = "AKIA[0-9A-Z]{16}" },
    @{ Name = "AWS Secret Key";       Pattern = "(?i)aws_secret_access_key\s*=\s*[A-Za-z0-9/+=]{40}" },
    @{ Name = "GitHub Token";         Pattern = "gh[pousr]_[A-Za-z0-9_]{36,}" },
    @{ Name = "OpenAI API Key";       Pattern = "sk-[A-Za-z0-9]{48}" },
    @{ Name = "Generic API Key";      Pattern = "(?i)(api[_-]?key|apikey)\s*[:=]\s*[\"'][A-Za-z0-9]{20,}[\"']" },
    @{ Name = "Connection String";    Pattern = "(?i)(password|pwd)\s*=\s*[^;]{8,}" },
    @{ Name = "Private Key";          Pattern = "-----BEGIN (RSA |EC )?PRIVATE KEY-----" },
    @{ Name = "Bearer Token";         Pattern = "(?i)bearer\s+[A-Za-z0-9\-._~+/]+=*" }
)

$findings = @()

foreach ($p in $patterns) {
    if ($contentToScan -match $p.Pattern) {
        $findings += $p.Name
    }
}

if ($findings.Count -gt 0) {
    $result = @{
        continue = $false
        stopReason = "BLOCKED: Potential secrets detected in file edit"
        systemMessage = "Secret scan found potential hardcoded credentials: $($findings -join ', '). Remove the secrets and use environment variables or configuration instead."
    }
    $result | ConvertTo-Json -Compress | Write-Output
    exit 2
}

# No secrets found - allow the edit
$result = @{
    continue = $true
    systemMessage = "Secret scan passed - no hardcoded credentials detected."
}
$result | ConvertTo-Json -Compress | Write-Output
exit 0

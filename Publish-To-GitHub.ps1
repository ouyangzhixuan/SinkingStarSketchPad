# Run this from your normal Windows PowerShell terminal if the Codex sandbox
# cannot write Git metadata. Git Credential Manager may ask you to sign in.
param([string]$CommitMessage = 'Fix keyboard input and preserve drawing mode in v3.3')
$ErrorActionPreference = 'Stop'
Set-Location -LiteralPath $PSScriptRoot
$expectedRemote = 'https://github.com/ouyangzhixuan/SinkingStarSketchPad.git'
function Invoke-Git {
    & git @args
    if ($LASTEXITCODE -ne 0) { throw ('Git failed: ' + ($args -join ' ')) }
}
if (-not (Test-Path -LiteralPath (Join-Path $PSScriptRoot '.git'))) { Invoke-Git init -b main }
$origin = (& git remote get-url origin 2>$null | Out-String).Trim()
if (-not $origin) { Invoke-Git remote add origin $expectedRemote }
elseif ($origin -ne $expectedRemote) { throw ('Unexpected origin; no files pushed: ' + $origin) }
Invoke-Git add .gitignore .gitattributes README.md LICENSE THIRD_PARTY_NOTICES.md build.ps1 test.ps1 Publish-To-GitHub.ps1 src tests third_party scripts config docs
Invoke-Git diff --cached --check -- . ':!third_party'
& git rev-parse --verify --quiet HEAD 2>$null | Out-Null
if ($LASTEXITCODE -ne 0) { Invoke-Git commit -m 'first commit' }
else {
    & git diff --cached --quiet
    if ($LASTEXITCODE -eq 1) { Invoke-Git commit -m $CommitMessage }
    elseif ($LASTEXITCODE -ne 0) { throw 'Could not inspect staged changes.' }
}
Invoke-Git branch -M main
Invoke-Git push -u origin main
Write-Output 'Published: https://github.com/ouyangzhixuan/SinkingStarSketchPad'

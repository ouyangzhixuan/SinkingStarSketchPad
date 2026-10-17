param([Parameter(Mandatory=$true)][string]$Compiler)
$ErrorActionPreference = 'Stop'
$out = Join-Path $PSScriptRoot 'build\tests'
[IO.Directory]::CreateDirectory($out) | Out-Null
foreach ($test in @('model_tests','grid_tests','grid_detect_tests','i18n_tests','input_tests')) {
    $exe = Join-Path $out ($test + '.exe')
    & $Compiler -std=c++17 -O2 -static (Join-Path $PSScriptRoot ('tests\' + $test + '.cpp')) -o $exe
    if ($LASTEXITCODE -ne 0) { throw ('Test compilation failed: ' + $test) }
    & $exe
    if ($LASTEXITCODE -ne 0) { throw ('Test failed: ' + $test) }
}
Write-Output 'All core tests passed. This does not constitute a full game compatibility test.'

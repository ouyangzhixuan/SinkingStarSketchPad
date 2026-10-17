param(
    [Parameter(Mandatory=$true)][ValidateSet('Install','Uninstall')][string]$Action,
    [string]$GamePath,
    [ValidateSet('Auto','en','zh-CN')][string]$Language = 'Auto'
)
$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSHOME 'Modules\Microsoft.PowerShell.Utility\Microsoft.PowerShell.Utility.psd1') -ErrorAction Stop
Import-Module (Join-Path $PSHOME 'Modules\Microsoft.PowerShell.Management\Microsoft.PowerShell.Management.psd1') -ErrorAction Stop
$uiChinese = $Language -eq 'zh-CN' -or ($Language -eq 'Auto' -and [Globalization.CultureInfo]::CurrentUICulture.Name.StartsWith('zh'))
function Msg([string]$English,[string]$Chinese) { if ($uiChinese) { return $Chinese }; return $English }
$packageRoot = Split-Path -Parent $PSScriptRoot
$manifest = Get-Content -LiteralPath (Join-Path $packageRoot 'package.json') -Raw | ConvertFrom-Json
$allowed = @('dxgi.dll','SinkingStarSketch.addon64','ReShade.ini','SinkingStarSketch-assets\NotoSansCJKsc-Regular.otf')
function Hash([string]$Path) { return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash }
function Known([object]$File,[string]$Actual) {
    return ($Actual -eq $File.SHA256 -or ($File.Name -eq 'SinkingStarSketch.addon64' -and $Actual -in @($manifest.KnownAddonHashes)))
}
function Get-GameRoot {
    if ([string]::IsNullOrWhiteSpace($GamePath)) {
        $record = Join-Path $packageRoot 'installation.json'
        if (Test-Path -LiteralPath $record) { $script:GamePath = (Get-Content -LiteralPath $record -Raw | ConvertFrom-Json).GameDirectory }
    }
    if ([string]::IsNullOrWhiteSpace($GamePath)) {
        $libraries = @()
        foreach ($key in @('HKCU:\Software\Valve\Steam','HKLM:\SOFTWARE\WOW6432Node\Valve\Steam')) {
            $steam = Get-ItemProperty -LiteralPath $key -ErrorAction SilentlyContinue
            if ($steam.SteamPath) { $libraries += $steam.SteamPath }
            if ($steam.InstallPath) { $libraries += $steam.InstallPath }
        }
        if (${env:ProgramFiles(x86)}) { $libraries += Join-Path ${env:ProgramFiles(x86)} 'Steam' }
        foreach ($library in @($libraries)) {
            $vdf = Join-Path $library 'steamapps\libraryfolders.vdf'
            if (Test-Path -LiteralPath $vdf) {
                foreach ($match in [regex]::Matches((Get-Content -LiteralPath $vdf -Raw),'"path"\s*"([^"]+)"')) {
                    $libraries += $match.Groups[1].Value.Replace('\\','\')
                }
            }
        }
        $found = @($libraries | Select-Object -Unique | ForEach-Object { Join-Path $_ 'steamapps\common\Order of the Sinking Star' } |
            Where-Object { Test-Path -LiteralPath (Join-Path $_ 'sinking_star.exe') -PathType Leaf } |
            ForEach-Object { (Resolve-Path -LiteralPath $_).Path } | Sort-Object -Unique)
        if ($found.Count -eq 1) { $script:GamePath = $found[0] }
    }
    if ([string]::IsNullOrWhiteSpace($GamePath) -or -not (Test-Path -LiteralPath $GamePath)) {
        throw (Msg 'Game not found or multiple installs found. Drag sinking_star.exe onto Install Mod.cmd or Uninstall Mod.cmd.' '未能唯一识别游戏目录。请把 sinking_star.exe 拖到安装Mod.cmd 或卸载Mod.cmd 上。')
    }
    $resolved = (Resolve-Path -LiteralPath $GamePath).Path
    if (Test-Path -LiteralPath $resolved -PathType Leaf) {
        if ((Split-Path -Leaf $resolved) -ne 'sinking_star.exe') { throw (Msg 'Select sinking_star.exe.' '请选择 sinking_star.exe。') }
        $resolved = Split-Path -Parent $resolved
    }
    if (-not (Test-Path -LiteralPath (Join-Path $resolved 'sinking_star.exe') -PathType Leaf)) { throw (Msg 'The target folder does not contain sinking_star.exe.' '目标目录中没有 sinking_star.exe。') }
    return $resolved.TrimEnd('\')
}
function Target([string]$Name) {
    if ($Name -notin $allowed) { throw (Msg 'Unexpected file name in the manifest.' '清单中含有不允许的文件名。') }
    $path = [IO.Path]::GetFullPath((Join-Path $gameRoot $Name))
    if (-not $path.StartsWith($rootPrefix,[StringComparison]::OrdinalIgnoreCase)) { throw 'Target path is outside the game folder.' }
    return $path
}
function New-Backup([string]$Prefix) {
    $name = $Prefix + (Get-Date -Format 'yyyyMMdd-HHmmss') + '-' + [guid]::NewGuid().ToString('N').Substring(0,8)
    $path = [IO.Path]::GetFullPath((Join-Path $gameRoot $name))
    if (-not $path.StartsWith($rootPrefix,[StringComparison]::OrdinalIgnoreCase)) { throw 'Backup path is outside the game folder.' }
    New-Item -ItemType Directory -Path $path | Out-Null
    return $path
}
function Input-Config([string]$Text) {
    # Preserve the user's other settings. Mode 1 is required for separate
    # mouse/keyboard capture; mode 2 blocks both even if ImGui releases keys.
    $section = [regex]::Match($Text,'(?ims)^\[INPUT\][^\r\n]*(?:\r?\n|$).*?(?=^\[|\z)')
    if (-not $section.Success) { return $Text + "`r`n[INPUT]`r`nInputProcessing=1`r`n" }
    $body = $section.Value
    if ($body -match '(?im)^InputProcessing\s*=') {
        $body = [regex]::Replace($body,'(?im)^InputProcessing\s*=[^\r\n]*','InputProcessing=1')
    } else { $body = $body.TrimEnd("`r","`n") + "`r`nInputProcessing=1`r`n" }
    return $Text.Substring(0,$section.Index) + $body + $Text.Substring($section.Index+$section.Length)
}
try {
    if (@($manifest.Files).Count -ne $allowed.Count -or @($manifest.Files.Name | Select-Object -Unique).Count -ne $allowed.Count) { throw (Msg 'Incomplete package manifest.' '发布包清单不完整。') }
    foreach ($file in $manifest.Files) {
        if ($file.Name -notin $allowed -or $file.SHA256 -notmatch '^[0-9A-Fa-f]{64}$') { throw (Msg 'Invalid package manifest.' '发布包清单无效。') }
    }
    $gameRoot = Get-GameRoot
    $rootPrefix = [IO.Path]::GetFullPath($gameRoot).TrimEnd('\') + '\'
    foreach ($process in @(Get-Process -Name sinking_star -ErrorAction SilentlyContinue)) {
        if ([string]::IsNullOrEmpty($process.Path) -or (Split-Path -Parent $process.Path) -eq $gameRoot) {
            throw (Msg 'Save your progress and exit the game before installing or uninstalling.' '请保存进度并正常退出游戏，再安装或卸载。')
        }
    }
    if ($Action -eq 'Install') {
        $payload = Join-Path $packageRoot 'game_files'
        $ownBinaries = $true
        foreach ($file in @($manifest.Files | Where-Object { $_.Name -in @('dxgi.dll','SinkingStarSketch.addon64') })) {
            $target = Target $file.Name
            if (-not (Test-Path -LiteralPath $target) -or -not (Known $file (Hash $target))) { $ownBinaries = $false }
        }
        # Validate every input and conflict before modifying the game folder.
        foreach ($file in $manifest.Files) {
            $inputPath = Join-Path $payload $file.Name
            if (-not (Test-Path -LiteralPath $inputPath) -or (Hash $inputPath) -ne $file.SHA256) { throw ((Msg 'Package checksum failed: ' '发布包校验失败：') + $file.Name) }
            $target = Target $file.Name
            if (Test-Path -LiteralPath $target) {
                if ($file.Name -eq 'ReShade.ini' -and $ownBinaries) { continue }
                if (-not (Known $file (Hash $target))) { throw ((Msg 'Conflicting file; nothing overwritten: ' '文件冲突，未覆盖任何文件：') + $file.Name) }
            }
        }
        $backup = $null
        $configPath = Target 'ReShade.ini'
        $configUpdate = $null
        if ($ownBinaries -and (Test-Path -LiteralPath $configPath)) {
            $reader = [IO.StreamReader]::new($configPath,[Text.UTF8Encoding]::new($false),$true)
            try { $configText = $reader.ReadToEnd(); $configEncoding = $reader.CurrentEncoding } finally { $reader.Dispose() }
            $nextConfig = Input-Config $configText
            if ($nextConfig -cne $configText) {
                $configUpdate = $nextConfig
                $backup = New-Backup 'SinkingStarSketch-upgrade-'
                Copy-Item -LiteralPath $configPath -Destination (Join-Path $backup 'ReShade.ini')
                $draft = Join-Path $gameRoot 'SinkingStarSketch-data\drafts.txt'
                if (Test-Path -LiteralPath $draft) { Copy-Item -LiteralPath $draft -Destination (Join-Path $backup 'drafts-before-upgrade.txt') }
            }
        }
        foreach ($file in $manifest.Files) {
            $target = Target $file.Name
            if (Test-Path -LiteralPath $target) {
                if ($file.Name -eq 'ReShade.ini' -or (Hash $target) -eq $file.SHA256) { continue }
                if (-not $backup) {
                    $backup = New-Backup 'SinkingStarSketch-upgrade-'
                    $draft = Join-Path $gameRoot 'SinkingStarSketch-data\drafts.txt'
                    if (Test-Path -LiteralPath $draft) { Copy-Item -LiteralPath $draft -Destination (Join-Path $backup 'drafts-before-upgrade.txt') }
                }
                $keep = Join-Path $backup $file.Name
                [IO.Directory]::CreateDirectory((Split-Path -Parent $keep)) | Out-Null
                Copy-Item -LiteralPath $target -Destination $keep
            }
            [IO.Directory]::CreateDirectory((Split-Path -Parent $target)) | Out-Null
            Copy-Item -LiteralPath (Join-Path $payload $file.Name) -Destination $target -Force
        }
        if ($null -ne $configUpdate) { [IO.File]::WriteAllText($configPath,$configUpdate,$configEncoding) }
        $actualFiles = @($manifest.Files | ForEach-Object { [ordered]@{Name=$_.Name;SHA256=(Hash (Target $_.Name))} })
        [ordered]@{Version=$manifest.Version;GameDirectory=$gameRoot;InstalledAt=(Get-Date).ToString('o');BackupDirectory=$backup;Files=$actualFiles} |
            ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $packageRoot 'installation.json') -Encoding UTF8
        Write-Output ((Msg 'Installed: ' '安装完成：') + $gameRoot)
        Write-Output (Msg 'Start the game: E = draw, G = cursor, B = show/hide. Choose Language in the toolbar.' '启动游戏后：E 绘图，G 指针，B 显隐；在工具栏 Language 中切换语言。')
    } else {
        $binaries = @($manifest.Files | Where-Object { $_.Name -in @('dxgi.dll','SinkingStarSketch.addon64') })
        if (@($binaries | Where-Object { Test-Path -LiteralPath (Target $_.Name) }).Count -eq 0) { Write-Output (Msg 'No mod loading files found; nothing to uninstall.' '没有找到 Mod 加载文件，无需卸载。');exit 0 }
        foreach ($file in $manifest.Files | Where-Object Name -ne 'ReShade.ini') {
            $target = Target $file.Name
            if ((Test-Path -LiteralPath $target) -and -not (Known $file (Hash $target))) { throw ((Msg 'Unrecognized file; nothing moved: ' '文件与已知版本不匹配，未移动任何文件：') + $file.Name) }
        }
        $backup = New-Backup 'SinkingStarSketch-disabled-'
        foreach ($file in $manifest.Files) {
            $target = Target $file.Name
            if (Test-Path -LiteralPath $target) {
                $keep = Join-Path $backup $file.Name
                [IO.Directory]::CreateDirectory((Split-Path -Parent $keep)) | Out-Null
                Move-Item -LiteralPath $target -Destination $keep
            }
        }
        Write-Output (Msg 'Uninstalled. Game saves, drafts, language settings and SVG exports were preserved.' '已卸载。游戏存档、草稿、语言设置与 SVG 导出文件均已保留。')
        Write-Output ((Msg 'Backup: ' '备份目录：') + $backup)
    }
    exit 0
} catch {
    Write-Host ((Msg 'Operation stopped: ' '操作已停止：') + $_.Exception.Message) -ForegroundColor Red
    exit 1
}

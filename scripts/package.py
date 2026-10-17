"""Build a public, offline installer package from the compiled add-on.

External runtime/font binaries are supplied explicitly and checksum-validated.
No game resources, local installation records, probes or build tools are packed.
"""
from pathlib import Path
import argparse
import hashlib
import json
import shutil
import zipfile

ROOT = Path(__file__).resolve().parent.parent
PINNED = {
    'runtime': '0CEE63F9C9F13F3AC909C5B4903F4DBB4B719A7AB3B4F13B0DEAF83C814B94F7',
    'font': '2C76254F6FC379FDDFCE0A7E84FB5385BB135D3E399294F6EEB6680D0365B74B',
    'font_license': '6A73F9541C2DE74158C0E7CF6B0A58EF774F5A780BF191F2D7EC9CC53EFE2BF2',
}
PREVIOUS_ADDONS = [
    'FAA89FF88BA9F47C108FDFEEA4026817B7318B969A21FA0300E8A3BA844EF6E2',
    '6D920DBFF0A89EB31B1276E8C48C2BF6DC1580D277376B922C65B95B69331846',
    'B5B8C1D73F82038D899417A33B0DAAE84DD12D60097B54FBB8B15E62197FF950',
    '617BF3F380952C0F7ED0EF63BD162759C1631A7979B9D8F23141280931FE5803',
    'D1CCA0B65A465E34CA1481F93EBA5860A2364A7C5B0F8C3BE312B7678E9C8240',
    '8995591A4296D8BD1C22D4AAFA7670F40D295738B3948A18057D55DB1EBAAD0E',
]

def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest().upper()

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--runtime', type=Path, required=True)
    parser.add_argument('--font', type=Path, required=True)
    parser.add_argument('--font-license', type=Path, required=True)
    parser.add_argument('--addon', type=Path, default=ROOT/'build/SinkingStarSketch.addon64')
    parser.add_argument('--staging', type=Path, default=ROOT/'build/package/SinkingStarSketchPad-3.3')
    args = parser.parse_args()
    for key, expected in PINNED.items():
        path = getattr(args, key)
        if not path.is_file() or digest(path) != expected:
            parser.error(f'Use the tested, unmodified {key} dependency; SHA256 must be {expected}')
    if not args.addon.is_file() or args.addon.read_bytes()[:2] != b'MZ':
        parser.error('Build the native add-on first, or pass --addon.')

    staging = args.staging.resolve()
    if staging.exists():
        parser.error(f'Staging folder already exists: {staging}. Move it aside before packaging again.')
    staging.mkdir(parents=True)
    payload = {
        'dxgi.dll': args.runtime,
        'SinkingStarSketch.addon64': args.addon,
        'ReShade.ini': ROOT/'config/ReShade.ini',
        'SinkingStarSketch-assets\\NotoSansCJKsc-Regular.otf': args.font,
    }
    manifest = {'Name':'SinkingStarSketchPad', 'Version':'3.3', 'ReleaseStatus':'Beta',
                'Source':'https://github.com/ouyangzhixuan/SinkingStarSketchPad', 'License':'MIT',
                'Languages':['en','zh-CN'], 'KnownAddonHashes':PREVIOUS_ADDONS, 'Files':[]}
    for name, source in payload.items():
        target = staging/'game_files'/Path(name.replace('\\','/'))
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source, target)
        manifest['Files'].append({'Name':name, 'SHA256':digest(source)})
    (staging/'package.json').write_text(json.dumps(manifest, indent=2)+'\n', encoding='utf-8-sig')
    (staging/'tools').mkdir()
    manager = (ROOT/'scripts/manage.ps1').read_text(encoding='utf-8-sig')
    (staging/'tools/manage.ps1').write_text(manager, encoding='utf-8-sig')
    for name, action, language in [('Install Mod','Install','en'), ('Uninstall Mod','Uninstall','en'),
                                   ('安装Mod','Install','zh-CN'), ('卸载Mod','Uninstall','zh-CN')]:
        text = f'''@echo off
setlocal
chcp 65001 >nul
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0tools\\manage.ps1" -Action {action} -GamePath "%~1" -Language {language}
set "sketchResult=%ERRORLEVEL%"
echo.
pause
exit /b %sketchResult%
'''
        (staging/(name+'.cmd')).write_bytes(text.replace('\n','\r\n').encode('utf-8'))
    for name in ('README_EN.md','README_zh-CN.md','CHANGELOG.md','VALIDATION.md'):
        shutil.copy2(ROOT/'docs'/name, staging/name)
    shutil.copy2(ROOT/'LICENSE', staging/'LICENSE')
    notice=(ROOT/'THIRD_PARTY_NOTICES.md').read_text(encoding='utf-8').replace('third_party/reshade-sdk/LICENSE-ReShade.md','licenses/ReShade-BSD-3-Clause.txt').replace('third_party/reshade-sdk/LICENSE-ImGui.txt','licenses/ImGui-MIT.txt').replace('third_party/runtime-notices','licenses')
    (staging/'THIRD_PARTY_NOTICES.md').write_text(notice,encoding='utf-8')
    licenses = staging/'licenses'
    shutil.copytree(ROOT/'third_party/runtime-notices', licenses)
    shutil.copy2(ROOT/'third_party/reshade-sdk/LICENSE-ReShade.md', licenses/'ReShade-BSD-3-Clause.txt')
    shutil.copy2(ROOT/'third_party/reshade-sdk/LICENSE-ImGui.txt', licenses/'ImGui-MIT.txt')
    shutil.copy2(args.font_license, licenses/'Noto-SIL-OFL-1.1.txt')
    dist = ROOT/'dist'
    dist.mkdir(exist_ok=True)
    archive = dist/'SinkingStarSketchPad-3.3.zip'
    with zipfile.ZipFile(archive, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as output:
        for path in sorted(staging.rglob('*')):
            if path.is_file():
                output.write(path, path.relative_to(staging).as_posix())
    with zipfile.ZipFile(archive) as output:
        if output.testzip() is not None:
            raise RuntimeError('ZIP integrity check failed')
        for file in manifest['Files']:
            data = output.read('game_files/'+file['Name'].replace('\\','/'))
            if hashlib.sha256(data).hexdigest().upper() != file['SHA256']:
                raise RuntimeError('Payload checksum mismatch')
    archive.with_suffix('.zip.sha256.txt').write_text(digest(archive)+'  '+archive.name+'\n', encoding='utf-8')
    print(archive)
    print('SHA256:', digest(archive))

if __name__ == '__main__':
    main()

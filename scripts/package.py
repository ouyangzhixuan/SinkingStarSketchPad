"""Build the minimal manual package: instructions plus three game files."""
from pathlib import Path
import argparse
import hashlib
import shutil
import zipfile

ROOT = Path(__file__).resolve().parent.parent
RUNTIME_SHA256 = '0CEE63F9C9F13F3AC909C5B4903F4DBB4B719A7AB3B4F13B0DEAF83C814B94F7'

def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest().upper()

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--runtime', type=Path, required=True)
    parser.add_argument('--addon', type=Path, default=ROOT/'build/SinkingStarSketch.addon64')
    parser.add_argument('--staging', type=Path, default=ROOT/'build/package/SinkingStarSketchPad-3.4.6-Minimal')
    args = parser.parse_args()
    if not args.runtime.is_file() or digest(args.runtime) != RUNTIME_SHA256:
        parser.error('Use the tested ReShade 6.8.0 full add-on runtime.')
    if not args.addon.is_file() or args.addon.read_bytes()[:2] != b'MZ':
        parser.error('Build the native add-on first.')
    staging = args.staging.resolve()
    if staging.exists():
        parser.error(f'Staging folder already exists: {staging}')
    (staging/'game_files').mkdir(parents=True)
    payload = {'dxgi.dll':args.runtime, 'SinkingStarSketch.addon64':args.addon,
               'ReShade.ini':ROOT/'config/ReShade.ini'}
    for name, source in payload.items():
        shutil.copy2(source, staging/'game_files'/name)
    config = (staging/'game_files/ReShade.ini').read_text(encoding='utf-8')
    if 'Font=\n' not in config or 'InputProcessing=1' not in config:
        raise RuntimeError('Expected automatic font selection and independent input capture.')
    # Retain complete license notices in the one installation document.
    # No fonts or Windows font files are redistributed.
    instructions = '\n\n'.join((ROOT/'docs'/name).read_text(encoding='utf-8')
                               for name in ('安装说明.txt','INSTALL_EN.txt'))
    notices = [ROOT/'LICENSE', ROOT/'third_party/reshade-sdk/LICENSE-ReShade.md',
               ROOT/'third_party/reshade-sdk/LICENSE-ImGui.txt']
    notices += sorted((ROOT/'third_party/runtime-notices').iterdir())
    instructions += '\n\n========== LICENSE NOTICES / 许可声明 ==========\n'
    for path in notices:
        if path.is_file():
            instructions += '\n--- '+path.name+' ---\n'+path.read_text(encoding='utf-8')+'\n'
    guide = '安装说明 Installation.txt'
    (staging/guide).write_text(instructions,encoding='utf-8-sig')
    dist = ROOT/'dist'
    dist.mkdir(exist_ok=True)
    archive = dist/'SinkingStarSketchPad-3.4.6-Minimal.zip'
    with zipfile.ZipFile(archive,'w',zipfile.ZIP_DEFLATED,compresslevel=9) as output:
        for path in sorted(staging.rglob('*')):
            if path.is_file():
                output.write(path,path.relative_to(staging).as_posix())
    with zipfile.ZipFile(archive) as output:
        expected = {guide} | {'game_files/'+name for name in payload}
        if set(output.namelist()) != expected or output.testzip() is not None:
            raise RuntimeError('Package contents or integrity check failed')
        for name, source in payload.items():
            if output.read('game_files/'+name) != source.read_bytes():
                raise RuntimeError('Payload differs from source')
        guide_text = output.read(guide).decode('utf-8-sig').replace('\r\n','\n')
        for path in notices:
            if path.is_file() and path.read_text(encoding='utf-8') not in guide_text:
                raise RuntimeError('License notice missing')
    archive.with_suffix('.zip.sha256.txt').write_text(digest(archive)+'  '+archive.name+'\n',encoding='utf-8')
    print(archive)
    print('Files: 4; size: %.2f MiB' % (archive.stat().st_size/1048576))
    print('SHA256:',digest(archive))

if __name__ == '__main__':
    main()

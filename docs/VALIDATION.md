# Validation — 3.2 Beta

- Translation catalog: complete English/Chinese entries, matching printf argument types, stable window IDs, system-language defaults and explicit overrides.
- Both UI languages rendered with the bundled Noto font in the DX12 test host: 240 frames each, resize, native back-buffer readback and device-removed status 0.
- Live English-to-Chinese and Chinese-to-English changes written through the real settings function; each next startup read the persisted choice.
- Grid fixture: 256 centers, spacing 1, matching camera frame. Existing world projection/draft validation remains applicable; the language update does not change the draft format.
- Windows PowerShell installer: fresh install, reinstall, versions 2.1/3.0/3.1 upgrades, old binary/draft backup, configuration and language preference preservation, uninstall, repeated uninstall, conflicting proxy rejection, tampered font rejection, English and Chinese output.
- Automatic discovery: secondary Steam library with Unicode and spaces, without an explicit game path.
- Release: payload hashes and ZIP integrity checked; no personal installation record, drafts, logs, probes, game assets, or nested archives.

UI preview images are from the synthetic DirectX 12 test host, not actual game levels. The preview build forces the toolbar open to inspect layout; the distributed add-on is the normal production build. Full visual alignment across actual game levels remains unverified. Keep the Beta label and check the cell-center preview in your level.

Naming update: display strings now use SinkingStarSketchPad. Executable code, file size, PE headers, persistent paths and window IDs are unchanged. The production add-on and both localized UI previews passed native DX12 loading/rendering checks; upgrading from the preceding 3.2 package preserves existing data and preferences.

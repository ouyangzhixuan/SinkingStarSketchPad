# Validation — 3.3 Beta

The 3.3 input update is validated separately from the earlier rendering/grid work below. Full keyboard/mouse coexistence in an actual game session still needs user verification.

- Core suites passed: model, projection/grid detection, localization, and focus/input policy.
- Native ReShade 6.8.0 / DX12 fixture: 240 frames, resize, device-removed status 0. The production overlay was exercised with deterministic focus changes; drawing intent, interrupted-stroke commit/save, unfinished text preservation (including runtime recreation), and separate capture flags passed. The fixture simulates focus rather than moving the desktop's actual focus.
- Messages sent only to the hidden test window: W/A reached the host while drawing, and W reached it again after runtime recreation; left-click messages did not. A did not select the arrow tool. No desktop input was generated.
- Production add-on smoke test: 240 frames with the grid fixture and resize, device-removed status 0, existing annotations rendered into the native back buffer.
- Installer: known 3.2 upgrade with InputProcessing=2, 0, absent key, or absent section; original config/add-on/draft backup, custom font retention, idempotent reinstall, uninstall, draft preservation, and fresh installation passed. When an existing routing key was present, config bytes changed only for its value.
- Required routing: `[INPUT] InputProcessing=1`. See the [ReShade 6.8.0 input-routing implementation](https://github.com/crosire/reshade/blob/v6.8.0/source/runtime_gui.cpp#L1405). The installer migrates this setting; manual installations need the same setting.

## Earlier 3.2 validation

- Translation catalog: complete English/Chinese entries, matching printf argument types, stable window IDs, system-language defaults and explicit overrides.
- Both UI languages rendered with the bundled Noto font in the DX12 test host: 240 frames each, resize, native back-buffer readback and device-removed status 0.
- Live English-to-Chinese and Chinese-to-English changes written through the real settings function; each next startup read the persisted choice.
- Grid fixture: 256 centers, spacing 1, matching camera frame. Existing world projection/draft validation remains applicable; the language update does not change the draft format.
- Windows PowerShell installer: fresh install, reinstall, versions 2.1/3.0/3.1 upgrades, old binary/draft backup, configuration and language preference preservation, uninstall, repeated uninstall, conflicting proxy rejection, tampered font rejection, English and Chinese output.
- Automatic discovery: secondary Steam library with Unicode and spaces, without an explicit game path.
- Release: payload hashes and ZIP integrity checked; no personal installation record, drafts, logs, probes, game assets, or nested archives.

UI preview images are from the synthetic DirectX 12 test host, not actual game levels. The preview build forces the toolbar open to inspect layout; the distributed add-on is the normal production build. Full visual alignment across actual game levels remains unverified. Keep the Beta label and check the cell-center preview in your level.

Naming update: display strings now use SinkingStarSketchPad. Executable code, file size, PE headers, persistent paths and window IDs are unchanged. The production add-on and both localized UI previews passed native DX12 loading/rendering checks; upgrading from the preceding 3.2 package preserves existing data and preferences.

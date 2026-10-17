# SinkingStarSketchPad 3.3

In-game drawing, scratch pages, a themed cursor, and cell-snapped route planning for **Order of the Sinking Star**. This is a native 64-bit ReShade add-on rendered into the game's DirectX 12 frame. It is not a separate desktop overlay.

**Release status: beta.** The game camera and grid data have been investigated, and automatic detection and projection have been tested. Full visual alignment across the game's levels has not been comprehensively verified. Check the cell-center preview in your level before relying on a route.

## Requirements

- A 64-bit Windows installation and the DirectX 12 version of the game (`sinking_star.exe`).
- The package includes the tested **ReShade 6.8.0 full add-on support** runtime, the add-on, a configuration file, and an openly licensed Noto CJK font. No separate ReShade download is needed for a fresh install.
- The installer runs with Windows PowerShell. It does not download files or modify the game executable, levels, or player saves.

## Install or upgrade

1. Save your progress and completely exit the game.
2. Extract the entire archive to a normal folder. Do not run the scripts from inside the ZIP.
3. Double-click **Install Mod.cmd**. It searches registered Steam libraries. If the game is not found, or there are multiple installations, drag the correct **sinking_star.exe** onto **Install Mod.cmd**.
4. Start the game. Press **E** to open the drawing toolbar.

The installer can upgrade known versions 2.1, 3.0, 3.1, and 3.2. It preserves drafts, exports, language preferences, and other ReShade settings. It backs up the old configuration and sets only `[INPUT] InputProcessing=1`, which is required for independent mouse/keyboard capture. Changed add-on files and the pre-upgrade draft are copied to a timestamped `SinkingStarSketch-upgrade-*` folder in the game directory.

If a conflicting `dxgi.dll`, add-on, font, or `ReShade.ini` is found, the installer stops before copying any files. Do not overwrite another graphics mod's files to force installation. For an existing compatible ReShade setup, consult **Existing ReShade installations** below.

The installer and uninstaller write a local `installation.json` beside the scripts. That file records your game path and must not be included if you repack and share an installed copy. Share the original release ZIP instead.

## Language

The toolbar's **Language / 语言** menu offers **System**, **English**, and **Chinese (Simplified)**. System uses Chinese for a Chinese Windows UI language and English otherwise. Changes take effect immediately and persist in:

`SinkingStarSketch-data/settings.ini`

You can also close the game and set this file manually:

```ini
[Interface]
Language=en
```

Other accepted values are `zh-CN` and `auto`. The setting changes the mod interface and notifications. Your annotations and the base game language are not translated.

## Controls

| Action | Key / input |
| --- | --- |
| Enter or leave drawing mode | E |
| Show or hide the mod cursor | G |
| Show or hide all marks | B |
| Cancel a stroke/text entry; otherwise return to the game | Esc |
| Pen / line / arrow | Alt+P / Alt+L / Alt+A |
| Rectangle / ellipse / text | Alt+R / Alt+O / Alt+T |
| Whole-mark eraser / cell path | Alt+K / Alt+H |
| Draw a stroke or shape | Hold and drag the left mouse button |
| Choose one of five ink colors | Alt+1-5 |
| Snap a line/arrow to 45 degrees; constrain rectangle/ellipse | Hold Shift |
| Undo | Ctrl+Z or right-click on the canvas |
| Redo | Ctrl+Y, or Ctrl+Shift+Z |
| Switch among three scratch pages | Ctrl+1 / Ctrl+2 / Ctrl+3 |
| Save | Ctrl+S |
| Clear this page, with undo | Ctrl+Shift+Delete |
| Finish text entry | Ctrl+Enter |

E/G/B only trigger without Ctrl, Shift, or Alt, and pause while the text entry dialog is open. They were checked against the game's default keymaps; customized keymaps may conflict. While drawing, ordinary keyboard input continues to the game, including movement and camera controls. Use Alt+letter for tools and Alt+1-5 for colors to avoid triggering tools with game movement keys. The mod captures the keyboard while text entry is open or Ctrl/Alt is held for mod shortcuts. Custom game bindings may still overlap those chords. Mouse input is reserved for drawing; press E to use mouse controls in the game. Alt+Tab preserves drawing mode and text entry, commits and saves the current stroke, and pauses mouse interaction until the game is active again. Release held mouse buttons before drawing again.

## Cell paths that follow the camera

1. Enter a level, press **E**, then **Alt+H** or click **Path Alt+H**.
2. Wait for **Auto grid** and **Game camera connected**. Detection generally needs a few seconds and enough regular game instances. No manual calibration is requested.
3. Enable **Cell-center preview** to inspect the snap points near your mouse.
4. Click a cell center to start a path. Click another cell in the same row or column to connect the intermediate centers.
5. Place a point at each corner. A diagonal target is rejected until you add the corner.
6. Click **Finish / New path** to begin a separate route.
7. Press **E** to return to the game. The path is stored using a world-space grid reference and is reprojected with the camera as it moves or zooms.

Right-click/Ctrl+Z undoes the most recent path addition and ends the active path. Alt+K selects the whole-path/whole-mark eraser. A path retains its own grid reference, so a later change in automatic detection does not move existing marks.

This tool marks routes only: it does not move the player, push boxes, check obstacles, or solve puzzles. Ordinary pen strokes, geometric shapes, and text are screen-space annotations and do not follow the world. Use a different scratch page for another level; pages are not automatically assigned to level names.

## Cursor artwork

Normal mode uses a pale gold crystal-blade pointer with a dark edge and a small engraved star. Drawing uses an open star-shaped crosshair with an ink-color indicator. The eraser uses an open gold rune ring. The pointer tip or crosshair center is the mouse hotspot. Vector artwork scales modestly at higher resolutions.

## Drafts, export, and limits

- Draft: `SinkingStarSketch-data/drafts.txt` in the game folder.
- Previous save: `drafts.txt.bak`.
- Language preferences: `settings.ini` in the same folder.
- **Export SVG** writes a transparent vector image to `SinkingStarSketch-data/exports`. World paths are projected using the camera available at export time. A path cannot be exported while no valid camera is available; other marks can still be exported.
- Up to 2,000 marks per page, 120,000 total points, and 60 undo steps. Undo history does not survive a restart.
- Old draft files can be read. Versions 3.x write the newer draft format; do not open it with 2.1. For a downgrade, restore the pre-upgrade draft from the backup.

## Uninstall

1. Completely exit the game.
2. Run **Uninstall Mod.cmd**, or drag `sinking_star.exe` onto it.
3. Verified mod files are moved to a timestamped `SinkingStarSketch-disabled-*` backup folder. Restart the game to run without the mod.

Player saves, drafts, language settings, and exports are preserved. A now-empty `SinkingStarSketch-assets` folder may remain. Unknown or changed binary/font files cause the tool to stop rather than move another mod's files.

## Manual installation and existing ReShade installations

For a fresh manual installation, copy the **contents** of `game_files` into the folder containing `sinking_star.exe`. The add-on and `dxgi.dll` must be next to the executable; keep the font in `SinkingStarSketch-assets`.

If you already use ReShade, back up that setup and verify its version and **full add-on support** before proceeding. You may copy only `SinkingStarSketch.addon64` and the font assets into your existing installation, enable loading add-ons from the game folder, and keep your own `dxgi.dll` and other ReShade settings. Set `[INPUT] InputProcessing=1` in `ReShade.ini` before starting the game; mode 2 still blocks the keyboard during drawing, and mode 0 does not protect game mouse input. Only the bundled 6.8.0 runtime has been validated here. Other ReShade versions and graphics proxy combinations are not verified. Select the bundled Noto font in ReShade's settings if Chinese glyphs are missing.

To disable a manual install, exit the game and move this add-on out of the game directory. Remove the bundled `dxgi.dll` only if it belongs to this mod's installation and is not shared by another setup.

## Troubleshooting and scope

- No toolbar: confirm installation beside the actual executable, completely restart the game, then press E. **Home** opens ReShade's own settings, whose language is separate from this mod.
- Grid/camera still waiting: enter a regular level, wait, and inspect the preview. The detector relies on upright instances on a regular horizontal grid; sloped terrain, unusual floors, camera/level transitions, wrapping-map behavior, and game updates need verification. Do not assume an arbitrary grid if detection is unavailable.
- Incorrect alignment: stop using that route and keep a screenshot plus a description of the level/camera view for a bug report. Do not treat the preview as an obstacle or walkability map.
- Missing Chinese glyphs after an upgrade: the installer preserves your old `ReShade.ini`. In ReShade settings, choose `SinkingStarSketch-assets/NotoSansCJKsc-Regular.otf` as the font and restart if needed.
- Diagnostics: `ReShade.log` and `SinkingStarSketch-data/status.txt`. Review logs and remove personal paths before posting them publicly.
- Current validation covers real-game upload data, grid inference, draft compatibility, both UI languages, DX12 rendering, and synthetic camera movement/zoom/resize. Full gameplay alignment across all levels remains unverified.

## Credits and third-party notices

This is an unofficial community tool, not an official game feature. The cursor artwork is drawn by the add-on; no extracted game artwork or game files are distributed.

- ReShade 6.8.0 by Patrick Mours and contributors: [official site](https://reshade.me/) — BSD 3-Clause notice in `licenses`.
- Dear ImGui by Omar Cornut and contributors: [repository](https://github.com/ocornut/imgui) — MIT notice in `licenses`.
- Noto Sans CJK: [official repository](https://github.com/notofonts/noto-cjk) — unmodified font and SIL Open Font License 1.1 notice in `licenses`.
- LLVM-MinGW runtime components: bundled notices in `licenses`.

Development and translations include generative-AI-produced code and text. Mod-specific source code and documentation are licensed under MIT, copyright 2026 ouyangzhixuan. Third-party components retain their original licenses.

The display name is **SinkingStarSketchPad**. The compatible add-on filename (`SinkingStarSketch.addon64`) and existing data/font folders retain their original names, so upgrades continue using your saved pages and preferences.

## Source code and license

The project is open source under the **MIT License**.

- Repository: [https://github.com/ouyangzhixuan/SinkingStarSketchPad](https://github.com/ouyangzhixuan/SinkingStarSketchPad)
- License: [MIT](https://github.com/ouyangzhixuan/SinkingStarSketchPad/blob/main/LICENSE)
- Bug reports: [GitHub Issues](https://github.com/ouyangzhixuan/SinkingStarSketchPad/issues)

Third-party components retain their original licenses.

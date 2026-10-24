# SinkingStarSketchPad 3.4.6

Current download: the 3.4.6 Minimal package contains only one bilingual installation guide (including license notices) and three game files: dxgi.dll, SinkingStarSketch.addon64 and ReShade.ini. Fonts, changelogs and developer material are not bundled. ReShade uses a system/built-in font; for Chinese missing glyphs, select an installed Chinese font in ReShade settings. Follow the bilingual installation document in the ZIP for the current installation.


In-game drawing, scratch pages, a themed cursor, and cell-snapped route planning for **Order of the Sinking Star**. This is a native 64-bit ReShade add-on rendered into the game's DirectX 12 frame. It is not a separate desktop overlay.

**Release status: beta.** The game camera and grid data have been investigated, and automatic detection and projection have been tested. Full visual alignment across the game's levels has not been comprehensively verified. Check the cell-center preview in your level before relying on a route.

## Requirements

- A 64-bit Windows installation and the DirectX 12 version of the game (`sinking_star.exe`).
- The package includes the tested **ReShade 6.8.0 full add-on support** runtime, the add-on, a configuration file. No separate ReShade download is needed for a fresh install.
- Manual file-copy installation. No CMD, batch, PowerShell or executable installer is included or required.

## Install or upgrade

Follow the bilingual installation document inside the Minimal ZIP, or [INSTALL_EN.txt](INSTALL_EN.txt) in the repository. The ZIP has three game files: dxgi.dll, SinkingStarSketch.addon64 and ReShade.ini. Copy them beside sinking_star.exe for a fresh installation with no existing graphics proxy. For an upgrade, replace only the add-on, preserve drafts/configuration and ensure [INPUT] InputProcessing=1. No scripts are used.

No font files are bundled. Font= is empty so ReShade selects a system/built-in font according to its own UI language. If Chinese glyphs are missing, select an installed Chinese-capable global font in ReShade settings (Home), such as C:\Windows\Fonts\msyh.ttc if present. The mod language setting does not select a font. To remove an old bundled font, first clear [STYLE] Font in the existing ReShade.ini, then remove that old asset.

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

E/G/B only trigger without Ctrl, Shift, or Alt, and pause while the text entry dialog is open. They were checked against the game's default keymaps; customized keymaps may conflict. While drawing, ordinary keyboard input continues to the game, including movement and camera controls. Use Alt+letter for tools and Alt+1-5 for colors to avoid triggering tools with game movement keys. The mod captures the keyboard while text entry is open or Ctrl/Alt is held for mod shortcuts. Custom game bindings may still overlap those chords. With the free camera disabled, mouse input is reserved for drawing; press E to use mouse controls in the game. Alt+Tab preserves drawing mode and text entry, commits and saves the current stroke, and pauses mouse interaction until the game is active again. Release held mouse buttons before drawing again.

## Experimental free camera

Press the single key **T**, or the toolbar's **Free camera** button, after entering a level. The feature starts disabled on each game launch and requires a validated main-view camera. WASD works while hovering an inactive panel; use right drag and wheel outside panels. Camera mode displays the cursor. Active widgets and text entry pause camera keyboard controls. It is integrated with the sketchpad; no second mod or project is needed.

| Action | Input |
| --- | --- |
| Pan on the world plane | W/A/S/D |
| Move up / down | Q / Z |
| Move faster | Hold Shift |
| Orbit the view around its captured focus | Hold right mouse button and drag |
| Zoom the lens | Mouse wheel outside the tool panels |
| Show / hide drawing toolbar | E |
| Undo an annotation while the camera is active | Ctrl+Z |
| Leave camera controls (keep view by default) | Esc or T |
| Restore the original game view | Restore game view button |

**Keep view when leaving camera controls** defaults on. T, Esc and the toolbar toggle release camera input while retaining the chosen view; T resumes adjustment without resetting it. Game keyboard controls and drawing become available again. The **Restore game view** button always restores, and remains available in the drawing toolbar while a view is held. Turn the checkbox off to restore automatically on exit. The checkbox persists, but the held pose does not survive a game restart; a detected scene/camera discontinuity also clears it. This holds the rendered view, so game-side mouse picking and culling still have the limits below. Existing saved speed settings are preserved; choose 5 in the panel if upgrading from a saved speed of 3.

The camera panel offers separate **Invert mouse X** and **Invert mouse Y** checkboxes. X reverses horizontal right-drag rotation; Y reverses vertical right-drag tilt. Neither changes WASD, height keys or the wheel. X defaults off; Y defaults on. Explicitly saved axis preferences are preserved. Movement speed and mouse sensitivity are adjustable and are saved together with these checkboxes in `SinkingStarSketch-data/settings.ini`; reopening the camera or restarting the game retains them. Resetting the view keeps these preferences.

Default movement speed is now 5 world units/second (3 in version 3.4.5), mouse sensitivity is 0.08 degrees/pixel (previously 0.30), Shift gives 2× speed, and wheel zoom changes by 6% per notch. Tilt stops at the overhead position and five degrees before the horizon, keeping the original side of the view. WASD directions follow yaw independently of tilt, preventing reversal when looking down.

The camera panel also offers X/Y/height offsets, yaw, tilt, zoom and reset-to-current-game-camera controls. While enabled, keyboard and mouse input are reserved for the camera and drawing, so WASD does not move the character. Text entry pauses camera movement. A scene/camera discontinuity may disable the override automatically. The normal 3.3-style keyboard/game coexistence returns when the free camera is disabled. Existing world paths use the same modified camera projection and remain anchored to cells; ordinary pen/text annotations remain in screen space.

**Experimental render override:** this changes validated DirectX 12 camera constants referenced by the submitted draw commands, not the game's CPU scene camera. Game-side culling, shadows, reflected views, visibility/streaming and mouse picking may still use the original view. Large translations, low angles or looking outside the originally visible area can reveal missing geometry or visual artifacts. It does not unlock unloaded levels or pause game simulation. Restore the game view if needed; full scene consistency is not yet verified in the actual game.

## Cell paths that follow the camera

1. Enter a level, press **E**, then **Alt+H** or click **Path Alt+H**.
2. Wait for **Auto grid** and **Game camera connected**. Detection generally needs a few seconds and enough regular game instances. No manual calibration is requested.
3. Enable **Cell-center preview** to inspect the snap points near your mouse.
4. Click a cell center to start a path. Click another cell in the same row or column to connect the intermediate centers.
5. Place a point at each corner. A diagonal target is rejected until you add the corner.
6. Click **Finish / New path** to begin a separate route.
7. Press **E** to return to the game. The path is stored using a world-space grid reference and is reprojected with the camera as it moves or zooms.

With the free camera disabled, right-click/Ctrl+Z undoes the most recent path addition and ends the active path. Alt+K selects the whole-path/whole-mark eraser. A path retains its own grid reference, so a later change in automatic detection does not move existing marks.

This tool marks routes only: it does not move the player, push boxes, check obstacles, or solve puzzles. Ordinary pen strokes, geometric shapes, and text are screen-space annotations and do not follow the world. Use a different scratch page for another level; pages are not automatically assigned to level names.

## Cursor artwork

Normal mode uses a pale gold crystal-blade pointer with a dark edge and a small engraved star. Drawing uses an open star-shaped crosshair with an ink-color indicator. The eraser uses an open gold rune ring. The pointer tip or crosshair center is the mouse hotspot. Vector artwork scales modestly at higher resolutions.

## Drafts, export, and limits

- Draft: `SinkingStarSketch-data/drafts.txt` in the game folder.
- Previous save: `drafts.txt.bak`.
- Language and camera preferences: `settings.ini` in the same folder.
- **Export SVG** writes a transparent vector image to `SinkingStarSketch-data/exports`. World paths are projected using the camera available at export time. A path cannot be exported while no valid camera is available; other marks can still be exported.
- Up to 2,000 marks per page, 120,000 total points, and 60 undo steps. Undo history does not survive a restart.
- Old draft files can be read. Versions 3.x write the newer draft format; do not open it with 2.1. For a downgrade, restore the pre-upgrade draft from the backup.

## Uninstall and existing ReShade setups

Exit the game and move SinkingStarSketch.addon64 outside the game directory. Keep SinkingStarSketch-data to preserve drafts and preferences. Remove dxgi.dll and ReShade.ini only if no other graphics mod uses them. Keep an existing ReShade setup when upgrading; only ReShade 6.8.0 full add-on support has been tested here. Required input setting: [INPUT] InputProcessing=1.

## Troubleshooting and scope

- No toolbar: confirm installation beside the actual executable, completely restart the game, then press E. **Home** opens ReShade's own settings, whose language is separate from this mod.
- Grid/camera still waiting: enter a regular level, wait, and inspect the preview. The detector relies on upright instances on a regular horizontal grid; sloped terrain, unusual floors, camera/level transitions, wrapping-map behavior, and game updates need verification. Do not assume an arbitrary grid if detection is unavailable.
- Incorrect alignment: stop using that route and keep a screenshot plus a description of the level/camera view for a bug report. Do not treat the preview as an obstacle or walkability map.
- Missing Chinese glyphs after an upgrade: choose an installed Chinese-capable global font in ReShade settings and restart if needed.
- Diagnostics: `ReShade.log` and `SinkingStarSketch-data/status.txt`. Review logs and remove personal paths before posting them publicly.
- Current validation covers real-game upload data, grid inference, draft compatibility, both UI languages, DX12 rendering, and synthetic camera movement/zoom/resize. Full gameplay alignment across all levels remains unverified.

## Credits and third-party notices

This is an unofficial community tool, not an official game feature. The cursor artwork is drawn by the add-on; no extracted game artwork or game files are distributed.

- ReShade 6.8.0 by Patrick Mours and contributors: [official site](https://reshade.me/) — BSD 3-Clause notice in `licenses`.
- Dear ImGui by Omar Cornut and contributors: [repository](https://github.com/ocornut/imgui) — MIT notice in `licenses`.
- LLVM-MinGW runtime components: bundled notices in `licenses`.

Development and translations include generative-AI-produced code and text. Mod-specific source code and documentation are licensed under MIT, copyright 2026 ouyangzhixuan. Third-party components retain their original licenses.

The display name is **SinkingStarSketchPad**. The compatible add-on filename (`SinkingStarSketch.addon64`) and existing data/font folders retain their original names, so upgrades continue using your saved pages and preferences.

## Source code and license

The project is open source under the **MIT License**.

- Repository: [https://github.com/ouyangzhixuan/SinkingStarSketchPad](https://github.com/ouyangzhixuan/SinkingStarSketchPad)
- License: [MIT](https://github.com/ouyangzhixuan/SinkingStarSketchPad/blob/main/LICENSE)
- Bug reports: [GitHub Issues](https://github.com/ouyangzhixuan/SinkingStarSketchPad/issues)

Third-party components retain their original licenses.

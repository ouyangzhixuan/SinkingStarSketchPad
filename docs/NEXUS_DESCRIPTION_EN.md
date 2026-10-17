# SinkingStarSketchPad — In-Game Drawing and Cell Paths

**Version 3.2 Beta · English / Simplified Chinese · Windows, DirectX 12**

An in-game scratchpad for Order of the Sinking Star: sketch ideas, place text notes, and plan routes snapped to cell centers. A themed crystal-blade cursor, star crosshair, and rune-ring eraser help keep annotations readable.

## Features
- Native ReShade add-on rendered inside the game frame.
- Pen, line, arrow, rectangle, ellipse, text and whole-mark eraser.
- Three automatically saved scratch pages, undo/redo and SVG export.
- Automatic grid inference with a cell-center preview; no manual calibration workflow.
- World-space path references reprojected using the game camera as it pans or zooms.
- English and Simplified Chinese interface with persistent language selection.

## Getting started
Exit the game, extract the complete archive, and run **Install Mod.cmd**. If Steam detection cannot identify a unique installation, drag **sinking_star.exe** onto the script. The tested ReShade 6.8.0 full add-on runtime and an openly licensed Noto font are included.

Press **E** for the toolbar, **G** to toggle the cursor and **B** to show/hide annotations. Use the **Language / 语言** menu to choose English or Chinese. For paths, press **E → H**, inspect the cell-center preview, then click along rows or columns and add a point at each turn.

## Compatibility and limitations
This is a beta. Automated validation includes real game upload data, grid inference, both UI languages, draft compatibility, DX12 rendering and synthetic camera movement, zoom and resize. Full visual alignment across all actual levels has not been comprehensively verified. Check the preview in your level, especially with unusual terrain, floors, transitions or wrapping maps.

Only path marks are world anchored. Ordinary drawing and text stay in screen space. Routes do not check obstacles, move the player, push boxes or solve puzzles. Pages are not automatically assigned to levels.

The installer preserves existing known-version settings and drafts and refuses conflicting graphics files. Do not overwrite another mod's dxgi.dll or ReShade setup. Only the bundled 6.8.0 full add-on runtime has been validated. See README_EN.md for existing ReShade installations.

## Uninstall
Exit the game and run **Uninstall Mod.cmd**. Verified mod files are moved to a backup folder; game saves, drafts, exports and language settings are retained.

## Credits and development
ReShade: Patrick Mours and contributors, BSD 3-Clause. Dear ImGui: Omar Cornut and contributors, MIT. Noto Sans CJK: SIL OFL 1.1. Runtime notices are included. No extracted game artwork or game files are supplied.

This is an unofficial community tool. Development used generative AI; the code, UI text and translations contain AI-generated content. This page text was also drafted with generative AI. Mod-specific source code and documentation are MIT-licensed, copyright 2026 ouyangzhixuan. Third-party components retain their own licenses.

## Source code and license

The project is open source under the **MIT License**.

- Repository: [https://github.com/ouyangzhixuan/SinkingStarSketchPad](https://github.com/ouyangzhixuan/SinkingStarSketchPad)
- License: [MIT](https://github.com/ouyangzhixuan/SinkingStarSketchPad/blob/main/LICENSE)
- Bug reports: [GitHub Issues](https://github.com/ouyangzhixuan/SinkingStarSketchPad/issues)

Third-party components retain their original licenses.

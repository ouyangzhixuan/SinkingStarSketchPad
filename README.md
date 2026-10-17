# SinkingStarSketchPad

An in-game sketchpad for **Order of the Sinking Star**: draw ideas, add text notes, and plan routes snapped to cell centers. This is a native 64-bit ReShade add-on rendered inside the game's DirectX 12 frame, with English and Simplified Chinese interfaces.

**Source repository:** [github.com/ouyangzhixuan/SinkingStarSketchPad](https://github.com/ouyangzhixuan/SinkingStarSketchPad)

[English usage guide](docs/README_EN.md) · [中文使用说明](docs/README_zh-CN.md) · [报告问题 / Issues](https://github.com/ouyangzhixuan/SinkingStarSketchPad/issues)

## Features

- Crystal-blade pointer, star drawing crosshair, and rune-ring eraser.
- Pen, lines, arrows, rectangles, ellipses, text, and whole-mark erasing.
- Three automatically saved scratch pages, undo/redo, and SVG export.
- Automatic grid inference and a cell-center preview, without manual calibration.
- World-space path marks reprojected with the game camera.
- Persistent System / English / Simplified Chinese language selection.

**Beta:** grid inference and synthetic camera projection have been tested, but full alignment across all actual game levels has not been comprehensively verified. Inspect the cell-center preview in your level. Routes do not check obstacles, solve puzzles, or control the player. Ordinary drawing and text stay in screen space.

## Use

For a prebuilt release package, follow its `Install Mod.cmd` instructions after exiting the game. Do not copy a GitHub source ZIP into the game as if it were a prebuilt mod.

Press **E** to open/close the toolbar, **G** for cursor visibility, and **B** for mark visibility. **E → Alt+H** selects cell paths. Keyboard movement and camera controls remain available while drawing. Alt+letter selects a tool; Alt+1-5 selects ink. Alt+Tab keeps drawing mode and commits the current stroke. Choose the interface language in **Language / 语言**. See the [full English guide](docs/README_EN.md) for installation, upgrades, existing ReShade setups, controls, and uninstalling.

The compatible add-on filename and persistent data folder remain `SinkingStarSketch.addon64` and `SinkingStarSketch-data` so existing drafts and preferences continue to work.

## Build from source

Requirements: 64-bit Windows and an x86-64 **LLVM-MinGW** toolchain. The retained build was validated with `llvm-mingw-20261006-ucrt-x86_64`. The ReShade 6.8.0 / Dear ImGui 1.92.5 docking headers used by the add-on are included in `third_party/reshade-sdk` with their original notices.

```powershell
git clone https://github.com/ouyangzhixuan/SinkingStarSketchPad.git
cd SinkingStarSketchPad
.\build.ps1 -Compiler 'C:\path\to\llvm-mingw\bin\clang++.exe'
.\test.ps1 -Compiler 'C:\path\to\llvm-mingw\bin\clang++.exe'
```

The add-on is written to `build/SinkingStarSketch.addon64`. Do not substitute an arbitrary MSVC-targeting `clang++`: the ImGui ABI adapter is explicitly designed for the MinGW/MSVC boundary used by this project.

To test in game, exit the game, back up an existing setup, install the compatible **ReShade 6.8.0 full add-on support** runtime, then place the built add-on beside `sinking_star.exe`. Keep compatible ReShade settings and a suitable UI font. The source repository does not include runtime DLLs, font binaries, game files, or a compiler. See [third-party components](THIRD_PARTY_NOTICES.md) for their official sources.

## Create a distributable package

After building, provide the tested ReShade runtime, the unmodified Noto Sans CJK SC Regular font and its license to the packaging script:

```powershell
python scripts/package.py --runtime 'C:\deps\ReShade64.dll' --font 'C:\deps\NotoSansCJKsc-Regular.otf' --font-license 'C:\deps\LICENSE-Noto.txt'
```

This creates a ZIP in `dist/` with bilingual guides, install/uninstall scripts, checksums, configuration and notices. It validates the external dependency hashes; it does not download dependencies. The package uses the source build output, not a binary branding patch. Verify a fresh package before distributing it. [Nexus publishing notes](docs/UPLOAD_GUIDE_zh-CN.md) and an [English page draft](docs/NEXUS_DESCRIPTION_EN.md) are included.

## Source layout

- `src/`: add-on, drawing model, camera/grid observers, cursor artwork, and localization.
- `tests/`: model, grid/projection, localization tests, and a synthetic DX12 rendering host.
- `config/`: example ReShade configuration for packaged installs.
- `scripts/`: portable package installer and release packager.
- `docs/`: English/Chinese usage, validation scope, and publishing materials.
- `third_party/`: the header dependencies and original licenses.

The DX12 host is a rendering harness, not an automatic gameplay test. Local paths, drafts, saves, logs, test probes, build outputs and release archives are excluded from Git.

## License and credits

Mod-specific source code and documentation are available under the **[MIT License](LICENSE)**, copyright 2026 **ouyangzhixuan**. Included third-party components keep their own licenses; see [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).

This is an unofficial community tool. Code, UI text and translations include generative-AI-produced content. No extracted game artwork or game files are distributed.

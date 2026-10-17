# Changelog

## 3.3 — Keyboard coexistence and focus persistence (Beta)
- Keep ordinary keyboard movement and camera input available while drawing; reserve the mouse for annotations.
- Use Alt+letter tool shortcuts and Alt+1-5 colors so game movement letters do not switch tools.
- Capture the keyboard only for text entry and Ctrl/Alt shortcut chords.
- Keep drawing mode and unfinished text across Alt+Tab; commit/save interrupted strokes and require mouse release before resuming.
- Preserve drawing mode and unfinished text when resize/fullscreen transitions recreate the rendering runtime.
- Set ReShade InputProcessing=1; known-version upgrades back up the old configuration and change only this routing setting.
- Add deterministic focus/input regression tests and a native DX12 overlay test fixture.

## 3.2 — English and Simplified Chinese (Beta)
- Display name unified as SinkingStarSketchPad; compatible file and data paths retained.
- Translate the toolbar, text entry dialog, camera/grid status, save/export messages, and HUD.
- Add System / English / Simplified Chinese selection with persistent preferences.
- Bundle an unmodified, openly licensed Noto CJK font for both languages.
- Add English and Chinese guides and installer/uninstaller entry points.
- Detect Steam libraries instead of embedding a particular user's installation path.
- Preserve earlier drafts, user configuration and language settings during known-version upgrades.

## 3.1
- Add crystal-blade pointer, star crosshair, and rune-ring eraser artwork.

## 3.0
- Add automatic grid detection and world-space path marks reprojected with the game camera.

## 2.1
- Use E/G/B for drawing, cursor and mark visibility; K for erasing.

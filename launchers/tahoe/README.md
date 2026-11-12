# Tahoe

A compact Applications palette based on the macOS Tahoe reference: search in
the title, five category pills, a scrollable app grid, and a rounded glass sheet.
Uses Linux desktop entries and the user's icon theme, rather than Apple assets.

Install from RyoStore → App launchers and select **Tahoe** in Ryoku Settings →
App Launcher. Super+Space opens it on the focused output. Type to search names,
descriptions and keywords across categories. Arrows select, Enter launches,
Tab/Shift+Tab cycle categories. Click a category again for all apps. Escape clears
search first, then closes. Clicking outside closes. Terminal apps use AppLaunch.

## Appearance

The **···** button opens live appearance controls. Defaults follow the Dynamic
Island's material, light/dark choice, opacity and font from its existing
`~/.config/ryoku/dynamic-island/settings.json`, read only. Choose **Liquid Glass**
to use glass independently of an Island in solid-black mode. The settings are
saved separately to `~/.config/ryoku/tahoe-launcher.json`; Reset restores inheritance.
Ryoku Settings owns grid columns, tile width, hidden apps, pinned apps and frost.
Search ranks name prefixes first and favorites next.

The material uses **Ryoku's installed Liquid Glass shader**, through a small
uniform adapter (`NativeGlass.qml`). Requires the Ryoku Python bar assets at
`/usr/share/ryoku/config/quickshell/shell/modules/bar/barstyles/python/assets/shaders/effects/liquid_glass.frag.qsb`.
It does not ship or compile a replacement shader. The glass samples one frozen
output frame and retains its source until closing to keep the texture valid. Providers without
`persistentScreenCapture` use an opaque surface and never request output capture.
The window uses `launcher-noblur` to avoid stacking compositor blur.

The launcher follows Ryoku reduced motion. Its window and effects are destroyed
after closing. It never runs typed shell commands or writes the shared settings.

The Island's dedicated `islandLauncher` shortcut opens its own embedded search.
Use Ryoku's standard **launcher** action (Super+Space) for Tahoe. The Island bar
continues running alongside it. No Island source fork is required.

## Development

From the worktree, pack with `python3 tools/pack-product.py launchers/tahoe` and
run `tests/validate-catalogue.sh`. Point RyoStore at the local worktree using the
repository's DEVELOP.md workflow, install Tahoe, then select it in Settings.

Maintained by the contributor in the upstream repository. GPL-3.0-or-later;
the native shader adapter follows Ryoku's distribution license. No Apple assets.

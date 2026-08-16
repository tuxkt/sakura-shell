# Sakura Shell dotfiles

Home-manager config for **[niri](https://github.com/niri-wm/niri)** (scrollable-tiling
Wayland compositor) + a re-themed/rebranded **[DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell)**
(the bar, dock, launcher, control center, etc.), running on NixOS.

This is a **standalone home-manager flake** — it doesn't touch the system-level
NixOS configuration (`/etc/nixos`), just the user environment.

## What's in here

- **Custom "Dusty Ice" Material 3 theme** — dusty pink primary + ice blue
  secondary accents, neutral dark surfaces (`home.nix`, theme JSON generated
  at `~/.config/DankMaterialShell/themes/dusty-ice.json`)
- **"Sakura Shell" rebrand** — the upstream DankMaterialShell package is
  patched at build time (via `overrideAttrs` + `substituteInPlace`) to swap
  visible "DankMaterialShell"/"DANK LINUX"/"DMS" text for "Sakura Shell" in
  the greeter, About tab, changelog, plugin manager, etc. Functional bits
  (the `~/.config/DankMaterialShell/` path, GitHub links, the `dms` CLI
  binary name) are deliberately left alone.
- **Custom launcher icon** — a heart instead of the default 9-dot app grid,
  colorized to match the theme (`assets/heart.png`)
- **KDE-style dock** — always visible, laptop-screen only (not the second
  monitor), with a pinned app launcher button
- **Catppuccin Mocha Pink cursor theme**
- **Ghostty** terminal, themed via matugen to match the shell's palette
- **Loupe** as the default image viewer (JPEG/PNG/etc had no handler before),
  with existing scheme-handler associations (Discord, Claude, GitHub
  Desktop, LM Studio) preserved
- **Bluetooth mic auto-switch disabled** — WirePlumber normally drops a
  connected headset to low-quality HSP/HFP the moment any app so much as
  glances at the microphone; this keeps it on high-quality A2DP permanently
- Earlier battery low/critical warning thresholds (25% / 12%)

## Not included here

niri's own config (`~/.config/niri/config.kdl` — keybinds, layout, the
video-wallpaper `spawn-at-startup` lines, the show-desktop toggle script)
lives outside this repo. The video wallpaper files themselves also aren't
included (they're just personal media files referenced by absolute path).

## Usage

```sh
nix run home-manager -- switch --flake .#tux
```

Requires flakes enabled (`nix.settings.experimental-features = [ "nix-command" "flakes" ]`
in your NixOS config).

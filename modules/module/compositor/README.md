# Compositor Module

## What is a Compositor?

A **compositor** is a display server and window manager combined. It handles:

1. **Rendering** — draws windows, effects, and UI onto your screen
2. **Window management** — arranges windows (tiling, floating, stacking)
3. **Input handling** — keyboards, mice, touchpads
4. **Compositing** — blends multiple window buffers into one final image

## Wayland vs X11

- **X11 (older)**: Display server and window manager are separate processes. You choose both independently (e.g., X11 + openbox, X11 + i3).
- **Wayland (modern)**: Display server and window manager are one monolithic compositor (Niri, Hyprland, Sway). It is the entire system.

## Compositors in this module

Currently supported:
- **Niri** — modern tiling, excellent Wayland support, your default

## How it fits here

Each compositor lives under `modules/module/compositor/<name>/` with its own NixOS module config.

The top-level `compositor.nix` module:
1. Declares the option `compositor.type = niri ...`
2. Imports the selected compositor's module
3. Computes `desktop.session.type` from the choice (wayland vs x11)
4. Enables display server setup (X11 fallback, inputs, outputs, etc.)

This allows swapping compositors by changing one option, and cascades all session/display logic automatically.

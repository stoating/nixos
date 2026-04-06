# NixOS Configuration – Copilot Instructions

## Overview
This is a NixOS flake-based configuration for a single host (`framework`, user `zack`).
It uses **flake-parts** and **import-tree** to automatically discover and load all `.nix` files under `modules/`.

## Key conventions

### Module auto-discovery via import-tree
- Every `.nix` file under `modules/` is automatically imported by `import-tree` — no manual registration needed.
- **Important:** `import-tree` uses git to enumerate files. Any new `.nix` file must be staged with `git add <file>` before it will be visible to Nix, even if uncommitted.

### flake-parts module pattern
All modules follow this wrapper structure:

```nix
{ self, inputs, ... }: {
  flake.nixosModules.<name> = { pkgs, lib, ... }: {
    # module body
  };
}
```

- The outer function receives flake-level args (`self`, `inputs`, etc.).
- The inner function is the actual NixOS module evaluated at build time.
- Only include `self` / `inputs` / etc. in the outer args if they are actually used.

### Naming
- NixOS modules are exposed as `flake.nixosModules.<name>` and referenced elsewhere as `self.nixosModules.<name>`.
- There is no `flake.homeModules` — home-manager modules are wrapped as `flake.nixosModules.<name>` and configure `home-manager.users.zack` directly.
- Module names use kebab-case (e.g. `home-zack`, `framework-configuration`, `framework-hardware`).

### Directory layout
```
modules/
  parts.nix                        # flake-parts systems + pkgs config
  home/zack/home.nix               # home-manager setup for user zack
  hosts/framework/
    configuration.nix              # main NixOS config, imports all other nixosModules
    framework.nix                  # framework-specific hardware tweaks
    hardware.nix                   # nixos-generate-config output
  programs/<name>/<name>.nix       # per-program nixosModules
```

New programs go in `modules/programs/<name>/<name>.nix` and are imported in
`modules/hosts/framework/configuration.nix` via `self.nixosModules.<name>`.

### home-manager
- Integrated via `inputs.home-manager.nixosModules.home-manager` (not standalone).
- Global options set in `modules/home/zack/home.nix`:
  ```nix
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  ```
- Per-program home-manager config lives in the program's own nixosModule and targets `home-manager.users.zack = { ... }`.
- `home.stateVersion` is set in `home.nix` and should not be changed unless intentionally migrating.

### Rebuilding
```bash
sudo nixos-rebuild switch --flake .#framework
```
Run from `/home/zack/nixos`. Remember to `git add` any new files first.

## Host & user facts
| Key | Value |
|-----|-------|
| Host | `framework` |
| Primary user | `zack` |
| Shell | `zsh` |
| Display server | Wayland (niri compositor) |
| State version | `25.11` |
| Timezone | `Europe/Berlin` |
| Keyboard layout | `de` |
| Unfree packages | allowed |

## Flake inputs
| Input | Purpose |
|-------|---------|
| `nixpkgs` | nixos-unstable |
| `flake-parts` | flake output structure |
| `import-tree` | auto-discovers `modules/**/*.nix` |
| `home-manager` | user environment management |
| `wrapper-modules` | wraps niri / noctalia with config |
| `noctalia-shell` | noctalia shell package |

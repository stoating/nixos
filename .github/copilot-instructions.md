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
- System-level modules are exposed as `flake.nixosModules.<name>` and referenced as `self.nixosModules.<name>`.
- Home-manager modules are exposed as `flake.homeModules.<name>` and referenced as `self.homeModules.<name>`.
- Module names use kebab-case (e.g. `home-zack`, `framework-configuration`, `framework-hardware`).
- User-specific home modules are prefixed with the username: `zacks-<tool>`.

### Directory layout
```
modules/
  parts.nix                             # flake-parts systems + pkgs config
  home/
    common/config/<tool>.nix            # shared lib values (flake.lib.<tool>.commonSettings)
    zack/
      home.nix                          # top-level user module: wires nixosModules + homeModules
      config/<tool>.nix                 # user-specific home overrides (flake.homeModules.zacks-<tool>)
  hosts/framework/
    default.nix                         # flake.nixosConfigurations.framework
    configuration.nix                   # main NixOS config (imports framework-hardware + home-zack)
    hardware.nix                        # nixos-generate-config output
  module/<category>/
    <category>.nix                      # root module: options interface + imports all tools
    <tool>/<tool>.nix                   # tool sub-module: package + default config
```

New programs follow the dendritic pattern — see `.github/instructions/adding-modules.instructions.md`.

### home-manager
- Integrated via `inputs.home-manager.nixosModules.home-manager` (not standalone).
- Global options set in `modules/home/zack/home.nix`:
  ```nix
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  ```
- Per-program home-manager config lives in `flake.homeModules` and is imported inside `home-manager.users.zack`.
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
| `noctalia` | noctalia shell package |
| `vscode` | follows nixpkgs (pinnable separately) |

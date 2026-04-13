# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Rebuild

```bash
sudo nixos-rebuild switch --flake .#framework
```

Run from `/home/zack/nixos`. **Any new `.nix` file must be staged (`git add`) before rebuilding** — `import-tree` uses git to enumerate files; unstaged files are invisible to Nix.

## Architecture

This is a NixOS flake for a single host (`framework`, user `zack`). All `.nix` files under `modules/` are auto-imported via `import-tree`. There is no manual module registration.

### Key inputs
| Input | Purpose |
|-------|---------|
| `flake-parts` | Structures flake outputs |
| `import-tree` | Auto-discovers `modules/**/*.nix` |
| `home-manager` | Integrated (not standalone) via `nixosModules.home-manager` |
| `noctalia` | Desktop shell package |
| `vscode` | Follows nixpkgs by default; pin by changing URL |

### Directory layout

```
modules/
  parts.nix                          # systems + pkgs (allowUnfree = true)
  hosts/framework/
    default.nix                      # nixosConfigurations.framework
    configuration.nix                # imports framework-hardware + home-zack
    hardware.nix                     # nixos-generate-config output
  home/
    common/config/<tool>.nix         # shared lib values (flake.lib.<tool>.commonSettings)
    zack/
      home.nix                       # wires all nixosModules + homeModules for user zack
      config/<tool>.nix              # user overrides (flake.homeModules.zacks-<tool>)
  module/<category>/
    <category>.nix                   # root module: options interface + imports all tools
    <tool>/<tool>.nix                # tool sub-module: package + default config
```

### Module wrapper pattern

Every `.nix` file wraps its module via flake-parts:

```nix
{ self, inputs, ... }: {
  flake.nixosModules.<name> = { pkgs, lib, config, ... }: {
    # NixOS module body
  };
}
```

For home-manager modules, use `flake.homeModules.<name>`. Only include `self`/`inputs` in the outer args if actually used.

**When a file declares `options` at the top level**, all `flake.*` assignments must move into an explicit `config = {}` block (bare assignments and `options` cannot coexist at the top level):

```nix
{ self, lib, ... }: {
  config.flake.homeModules.foo = { ... }: { };  # moved into config
  options.flake.foo.bar = lib.mkOption { type = lib.types.str; };
}
```

### Root module pattern

Each category's root module (`<category>.nix`) imports all tool sub-modules and declares `options.<category>.programs.<tool>.enable` options. It has **no `config` block** — each sub-module gates itself.

### Tool sub-module pattern

Each sub-module reads the enable option and gates itself with `lib.mkIf`:

```nix
{ ... }: {
  flake.homeModules.<tool> = { lib, config, ... }: {
    programs.<tool> = lib.mkIf config.<category>.programs.<tool>.enable {
      enable = true;
      # default configuration...
    };
  };
}
```

Single-boolean shorthand is also common: `programs.<tool>.enable = lib.mkIf config.<category>.programs.<tool>.enable true;`

**Self-contained variant** (used by theming sub-modules): the sub-module declares its own option and a `config = lib.mkIf` block, skipping the root module's option list entirely.

### Naming conventions
- NixOS modules: `flake.nixosModules.<kebab-case>`, referenced as `self.nixosModules.<name>`
- Home-manager modules: `flake.homeModules.<kebab-case>`, referenced as `self.homeModules.<name>`
- User override modules: named `zacks-<tool>` (e.g. `zacks-vscode`)
- Common defaults exported as: `flake.lib.<tool>.commonSettings`

### Common defaults pattern

Shared settings live in `home/common/config/<tool>.nix` as `flake.lib.<tool>.commonSettings`. User configs overlay them with `lib.recursiveUpdate`:

```nix
programs.<tool>.settings = lib.recursiveUpdate self.lib.<tool>.commonSettings {
  # user-specific overrides
};
```

### System-level modules with type selectors

Categories with swappable implementations (compositor, shell-desktop) use a `nixosModule` with an enum `type` option. These are imported in `home/zack/home.nix` outside the `home-manager.users.zack` block, and their `type` is set there (e.g. `compositor.type = "niri"`).

## Adding a new program — checklist

1. Create `modules/module/<category>/<tool>/<tool>.nix` — gate its config with `lib.mkIf config.<category>.programs.<tool>.enable`
2. Add `self.homeModules.<tool>` to imports in the category root module
3. Add `<tool>.enable = lib.mkEnableOption "..."` to the root module's options
4. Enable in `modules/home/zack/home.nix`: `<category>.programs.<tool>.enable = true`
5. If user config needed: create `modules/home/zack/config/<tool>.nix` and import it in `home.nix`
6. If shared defaults needed: add `modules/home/common/config/<tool>.nix`
7. `git add` every new file
8. Rebuild

## Host facts

| Key | Value |
|-----|-------|
| Host | `framework` |
| User | `zack` |
| Shell | `zsh` |
| Compositor | `niri` (Wayland) |
| Desktop shell | `noctalia` |
| State version | `25.11` — do not change unless intentionally migrating |
| Timezone | `Europe/Berlin` |
| Keyboard layout | `de` |

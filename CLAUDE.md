# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Rebuild

```bash
sudo nixos-rebuild switch --flake .#framework
```

Run from `/home/zack/nixos`. **Any new `.nix` file must be staged (`git add`) before rebuilding** — `import-tree` uses git to enumerate files; unstaged files are invisible to Nix.

## Architecture

This is a NixOS flake with two hosts: `framework` (laptop, user `zack`) and `quote-assistant` (Hetzner VPS). All `.nix` files under `modules/` are auto-imported via `import-tree`. There is no manual module registration.

### Key inputs

| Input | Purpose |
| ------- | --------- |
| `nixpkgs` | nixos-unstable channel |
| `flake-parts` | Structures flake outputs |
| `import-tree` | Auto-discovers `modules/**/*.nix` |
| `home-manager` | Integrated (not standalone) via `nixosModules.home-manager`; follows nixpkgs |
| `noctalia` | Desktop shell package (pinned to v4.7.2) |
| `wrapper-modules` | Used to wrap niri with custom settings |
| `claude-desktop` | Claude Desktop Linux build |
| `vscode` | Follows nixpkgs by default; pin by changing URL |

### Binary caches

| Cache | Where configured |
| ------- | ----------------- |
| `noctalia.cachix.org` | `flake.nix` nixConfig |
| `cache.nixos.org` | `configuration.nix` nix.settings |
| `devenv.cachix.org` | `configuration.nix` nix.settings |

### Directory layout

``` bash
modules/
  parts.nix                            # systems + pkgs (allowUnfree = true)
  hosts/
    framework/
      default.nix                      # nixosConfigurations.framework
      configuration.nix                # system config (boot, networking, nix.settings)
      hardware.nix                     # nixos-generate-config output
    hetzner/quote-assistant/
      default.nix                      # nixosConfigurations.quote-assistant
      configuration.nix                # Nginx + Java app service
  home/
    common/config/
      monitors.nix                     # flake.lib.monitors = {hp, fw} connector names
      theme.nix                        # flake.lib.theme = {colors, opacity, ...} (Nord)
      noctalia.nix                     # flake.lib.noctalia.commonSettings (400+ line defaults)
    zack/
      home.nix                         # wires all nixosModules + homeModules for user zack
      config/<tool>.nix                # user overrides (flake.homeModules.zacks-<tool>)
      peripherals/<item>.nix           # hardware overrides (flake.nixosModules.zacks-<item>)
    vps/
      admin.nix                        # nixosModule for VPS admin user
      app.nix                          # nixosModule for VPS app service user
  module/<category>/
    <category>.nix                     # root module: options interface + imports all tools
    packages/<tool>.nix                # tool sub-module: package + default config
  peripherals/
    peripherals.nix                    # aggregates keyboard, monitors, nas, printer, wally-cli
    keyboard/keyboard.nix              # config.keyboard.xkb.{layout,variant} options
    monitors/monitors.nix              # config.monitors[] schema
    nas/nas.nix                        # SMB mount options
    printer/printer.nix                # CUPS options
```

### Module categories

All homeModules unless noted. Options live under `config.<category>.programs.<tool>.enable` (or `config.<category>.languages.<tool>.enable` for development languages).

| Category | Programs / options |
| ---------- | -------------------- |
| `ai` | claude-code, claude-desktop, codex, whisper-cpp |
| `backup` | restic |
| `browser` | chrome, chromium, firefox |
| `containers` | docker, podman, podman-desktop |
| `data` | jq, yq |
| `development` | **programs:** git, gh, lazygit, direnv, devenv, delta — **languages:** python, uv, clojure, nodejs, jdk, clj-kondo |
| `editor` | vscode, vim, neovim, emacs |
| `files` | fd, ripgrep, yazi, mc |
| `media` | asciinema, auto-editor, ffmpeg, discord, kdenlive, obs-studio, pear-desktop |
| `monitoring` | btop, bandwhich, gping |
| `passwords` | keepassxc |
| `productivity` | libreoffice, onlyoffice, wpsoffice |
| `shell-cli` | zsh, fish, nushell |
| `shell-tools` | atuin, atuin-desktop, fzf, zoxide, navi, tldr, starship, comma |
| `terminal` | tmux, ghostty |
| `theming` | bat, cursor, gtk (self-contained; see below) |
| `compositor` | **nixosModule** — `config.compositor.type` enum (currently: "niri") |
| `shell-desktop` | **nixosModule** — `config.shell-desktop.type` string (currently: "noctalia") |

### Module wrapper pattern

Every `.nix` file wraps its module via flake-parts:

```nix
{ self, inputs, ... }: {
  flake.nixosModules.<name> = { pkgs, lib, config, ... }: {
    # NixOS module body
  };
}
```

For home-manager modules use `flake.homeModules.<name>`. Only include `self`/`inputs` in the outer args if actually used.

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

Each sub-module reads the enable option and gates itself with `lib.mkIf`. Always use the block form:

```nix
{ ... }: {
  flake.homeModules.<tool> = { lib, config, pkgs, ... }: {
    home.packages = lib.mkIf config.<category>.programs.<tool>.enable [
      pkgs.<tool>
    ];
  };
}
```

Tools with a home-manager `programs.<tool>` module use that instead of `home.packages`:

```nix
programs.<tool> = lib.mkIf config.<category>.programs.<tool>.enable {
  enable = true;
};
```

**Self-contained variant** (used by theming sub-modules): the sub-module declares its own option and a `config = lib.mkIf` block, skipping the root module's option list entirely.

### System-level modules with type selectors

`compositor` and `shell-desktop` are nixosModules with an enum/string `type` option. They are imported in `home/zack/home.nix` **outside** the `home-manager.users.zack` block, and their `type` is set there:

```nix
compositor.type = "niri";
shell-desktop.type = "noctalia";
```

### Niri wrapper pattern

The niri sub-module uses `wrapper-modules` to compose settings without patching:

```nix
package = inputs.wrapper-modules.wrappers.niri.wrap { inherit pkgs; settings = { ... }; };
```

### Common defaults pattern

Shared settings live in `home/common/config/<tool>.nix` and are exported as `flake.lib.*`. User configs overlay them with `lib.recursiveUpdate`:

```nix
programs.<tool>.settings = lib.recursiveUpdate self.lib.<tool>.commonSettings {
  # user-specific overrides
};
```

Current lib exports: `self.lib.monitors`, `self.lib.theme`, `self.lib.noctalia.commonSettings`.

### Naming conventions

- NixOS modules: `flake.nixosModules.<kebab-case>`, referenced as `self.nixosModules.<name>`
- Home-manager modules: `flake.homeModules.<kebab-case>`, referenced as `self.homeModules.<name>`
- User override modules: named `zacks-<tool>` (e.g. `zacks-vscode`)
- Common defaults exported as: `flake.lib.<tool>.commonSettings`

## Adding a new program — checklist

1. Create `modules/module/<category>/packages/<tool>.nix` — gate its config with `lib.mkIf config.<category>.programs.<tool>.enable`
2. Add `self.homeModules.<tool>` to imports in the category root module
3. Add `<tool>.enable = lib.mkEnableOption "..."` to the root module's options
4. Enable in `modules/home/zack/home.nix`: `<category>.programs.<tool>.enable = true`
5. If user config needed: create `modules/home/zack/config/<tool>.nix` and import it in `home.nix`
6. If shared defaults needed: add `modules/home/common/config/<tool>.nix`
7. `git add` every new file
8. Rebuild

## Running unavailable tools

If a CLI tool is not found during a task, try prefixing the command with `,` (comma) before giving up or asking the user to install it. Comma runs any nixpkg on the fly without permanently installing it:

```bash
, <tool> [args...]   # e.g. ", alejandra ." or ", nix-tree"
```

This avoids the need for `nix shell -p <pkg> --command <tool>` boilerplate.

## Host facts

| Key | Value |
| ----- | ------- |
| Host | `framework` |
| User | `zack` |
| Shell | `zsh` |
| Compositor | `niri` (Wayland) |
| Desktop shell | `noctalia` |
| Display manager | GDM |
| Audio | PipeWire (ALSA + Pulse) |
| Keyboard layout | `de` |
| Monitors | `DP-1` (HP external) + `eDP-2` (built-in, scale 1.5) |
| NAS | 192.168.178.145 — SMB share "homes" + Synology Drive |
| Printer | Brother MFC-J4340DW at 192.168.178.50 |
| Timezone | `Europe/Berlin` |
| State version | `25.11` — do not change unless intentionally migrating |
| Theme | Nord (colors, GTK: Nordic, bat/delta/vscode/ghostty all Nord) |

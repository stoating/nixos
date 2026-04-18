# AGENTS.md

Guidance for Codex and other coding agents working in this repository.

## Scope

These instructions apply to the entire repository. Follow more specific `AGENTS.md`
files if they are added in subdirectories.

## NixOS Management Skill

The `nixos-managing/` directory at the repo root contains a structured skill
for managing NixOS systems. It is placed there by Nix (pinned via `flake.lock`,
sourced from `michalzubkowicz/nixos-management-skill`) and is gitignored.

1. Treat `nixos-managing/SKILL.md` as the entry point — it contains a decision
   table pointing to the right reference file for the task.
2. Load reference files on demand based on that table:
   - `configuration.md` — flakes, modules, packages, services, secrets
   - `vm-management.md` — `nixos-rebuild`, generations, rollback, remote deploy
   - `installation.md` — initial install, disko, hardware configuration
   - `image-building.md` — ISO, VM, disk images
   - `impermanence.md` — ephemeral root, wipe-on-boot
   - `luks.md` — disk encryption, remote unlock (SSH, Tailscale)
   - `monitoring.md` — health checks and alerting
   - `anti-patterns.md` — common mistakes
3. Verify every NixOS option before suggesting it.
4. Ask about execution context (local vs. remote deploy) before suggesting
   commands.

## Rebuild

Run rebuilds from `/home/zack/nixos`:

```bash
sudo nixos-rebuild switch --flake .#framework
```

Any new `.nix` file must be staged with `git add` before rebuilding. This
repository uses `import-tree`, which enumerates files through git, so unstaged
new files are invisible to Nix.

## Project Shape

This is a NixOS flake with two hosts:

- `framework`: laptop for user `zack`
- `quote-assistant`: Hetzner VPS

All `.nix` files under `modules/` are auto-imported through `import-tree`.
Do not add manual module registration unless changing that architecture
intentionally.

Important inputs:

- `nixpkgs`: `nixos-unstable`
- `flake-parts`: structures flake outputs
- `import-tree`: auto-discovers `modules/**/*.nix`
- `home-manager`: integrated through `nixosModules.home-manager`
- `noctalia`: desktop shell package pinned to `v4.7.2`
- `wrapper-modules`: wraps `niri` with custom settings
- `claude-desktop`: Claude Desktop Linux build
- `vscode`: follows `nixpkgs` by default

Binary caches:

- `noctalia.cachix.org`: configured in `flake.nix`
- `cache.nixos.org`: configured in host `configuration.nix`
- `devenv.cachix.org`: configured in host `configuration.nix`

## Layout

```text
modules/
  parts.nix
  hosts/
    framework/
    hetzner/quote-assistant/
  home/
    common/config/
    zack/
    vps/
  module/<category>/
    <category>.nix
    packages/<tool>.nix
  peripherals/
```

Shared defaults live in `modules/home/common/config/` and are exported under
`flake.lib.*`. User-specific configuration lives under `modules/home/zack/`.

## Module Categories

Most categories are home-manager modules. Options generally live under
`config.<category>.programs.<tool>.enable`, or
`config.<category>.languages.<tool>.enable` for development languages.

Current categories:

- `ai`: claude-code, claude-desktop, codex, whisper-cpp
- `backup`: restic
- `browser`: chrome, chromium, firefox
- `containers`: docker, podman, podman-desktop
- `data`: jq, yq
- `development`: git, gh, lazygit, direnv, devenv, delta, python, uv,
  clojure, nodejs, jdk, clj-kondo
- `editor`: vscode, vim, neovim, emacs
- `files`: fd, ripgrep, yazi, mc
- `media`: asciinema, auto-editor, ffmpeg, discord, kdenlive, obs-studio,
  pear-desktop
- `monitoring`: btop, bandwhich, gping
- `passwords`: keepassxc
- `productivity`: libreoffice, onlyoffice, wpsoffice
- `shell-cli`: zsh, fish, nushell
- `shell-tools`: atuin, atuin-desktop, fzf, zoxide, navi, tldr, starship,
  comma
- `terminal`: tmux, ghostty
- `theming`: bat, cursor, gtk
- `compositor`: NixOS module, selected with `config.compositor.type`
- `shell-desktop`: NixOS module, selected with `config.shell-desktop.type`

## Flake Module Wrapper Pattern

Every `.nix` file wraps its module via flake-parts:

```nix
{ self, inputs, ... }: {
  flake.nixosModules.<name> = { pkgs, lib, config, ... }: {
    # NixOS module body
  };
}
```

Use `flake.homeModules.<name>` for home-manager modules. Only include outer
arguments such as `self` or `inputs` when the file actually uses them.

If a file declares `options` at the top level, put all `flake.*` assignments
inside an explicit `config = { ... };` block:

```nix
{ self, lib, ... }: {
  config.flake.homeModules.foo = { ... }: { };

  options.flake.foo.bar = lib.mkOption {
    type = lib.types.str;
  };
}
```

Bare `flake.*` assignments and top-level `options` cannot coexist.

## Root Module Pattern

Each category root module, such as `modules/module/editor/editor.nix`, imports
all tool sub-modules and declares enable options. It should not have a `config`
block. Each tool sub-module gates itself.

## Tool Sub-Module Pattern

Each sub-module reads its enable option and gates configuration with
`lib.mkIf`. Use block form consistently:

```nix
{ ... }: {
  flake.homeModules.<tool> = { lib, config, pkgs, ... }: {
    home.packages = lib.mkIf config.<category>.programs.<tool>.enable [
      pkgs.<tool>
    ];
  };
}
```

Prefer home-manager's native `programs.<tool>` module when available:

```nix
programs.<tool> = lib.mkIf config.<category>.programs.<tool>.enable {
  enable = true;
};
```

The theming modules use a self-contained variant: the sub-module declares its
own option and uses `config = lib.mkIf ...`, instead of listing the option in a
category root module.

## System-Level Selectors

`compositor` and `shell-desktop` are NixOS modules with selector options. They
are imported in `modules/home/zack/home.nix` outside the
`home-manager.users.zack` block:

```nix
compositor.type = "niri";
shell-desktop.type = "noctalia";
```

The `niri` sub-module uses `wrapper-modules` to compose settings without
patching:

```nix
package = inputs.wrapper-modules.wrappers.niri.wrap {
  inherit pkgs;
  settings = { };
};
```

## Common Defaults

Shared settings are exported as `flake.lib.*` from files under
`modules/home/common/config/`. User configs overlay them with
`lib.recursiveUpdate`:

```nix
programs.<tool>.settings = lib.recursiveUpdate self.lib.<tool>.commonSettings {
  # user-specific overrides
};
```

Current exports:

- `self.lib.monitors`
- `self.lib.theme`
- `self.lib.noctalia.commonSettings`

## Naming

- NixOS modules: `flake.nixosModules.<kebab-case>`, referenced as
  `self.nixosModules.<name>`
- Home-manager modules: `flake.homeModules.<kebab-case>`, referenced as
  `self.homeModules.<name>`
- User override modules: `zacks-<tool>`
- Common defaults: `flake.lib.<tool>.commonSettings`

## Adding A Program

1. Create `modules/module/<category>/packages/<tool>.nix`.
2. Gate config with `lib.mkIf config.<category>.programs.<tool>.enable`.
3. Add `self.homeModules.<tool>` to imports in the category root module.
4. Add `<tool>.enable = lib.mkEnableOption "..."` to the root module options.
5. Enable it in `modules/home/zack/home.nix`.
6. If user config is needed, create `modules/home/zack/config/<tool>.nix` and
   import it in `home.nix`.
7. If shared defaults are needed, add `modules/home/common/config/<tool>.nix`.
8. Stage every new `.nix` file with `git add`.
9. Rebuild.

## Running Tools

If a CLI tool is unavailable, try prefixing it with `,` before deciding it must
be installed:

```bash
, <tool> [args...]
```

Examples:

```bash
, alejandra .
, nix-tree
```

This uses `comma` to run nixpkgs tools on demand without permanently installing
them.

## Host Facts

- Host: `framework`
- User: `zack`
- Shell: `zsh`
- Compositor: `niri` on Wayland
- Desktop shell: `noctalia`
- Display manager: GDM
- Audio: PipeWire with ALSA and Pulse
- Keyboard layout: `de`
- Monitors: `DP-1` HP external and `eDP-2` built-in at scale `1.5`
- NAS: `192.168.178.145`, SMB share `homes`, plus Synology Drive
- Printer: Brother MFC-J4340DW at `192.168.178.50`
- Timezone: `Europe/Berlin`
- State version: `25.11`; do not change unless intentionally migrating
- Theme: Nord across GTK, bat, delta, VSCode, and ghostty

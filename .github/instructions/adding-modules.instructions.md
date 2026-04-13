---
applyTo: "modules/**/*.nix"
---

# Adding New Modules to This Repository

## The Dendritic Pattern

Modules are organised in a tree (dendritic) structure. Each **category** (browser, shell, ide, etc.) has:

1. **A root module** — defines the shared options interface and imports all tool sub-modules.
2. **Tool sub-modules** — one per tool, containing the actual package/config for that tool.
3. **User override modules** — user-specific extensions layered on top of the generic tool config.
4. **Common defaults** (optional) — shared settings exported as library values for multiple users to reuse.

```
modules/module/<category>/
  <category>.nix          ← root module: options + imports all tools
  <tool-a>/
    <tool-a>.nix          ← tool sub-module: installs and configures tool A
  <tool-b>/
    <tool-b>.nix          ← tool sub-module: installs and configures tool B

modules/home/<user>/config/
  <tool>.nix              ← user override: user-specific settings for a tool

modules/home/common/config/
  <tool>.nix              ← common defaults: shared lib values any user can reference
```

---

## Module Wrapper Pattern

Every `.nix` file exports its module via flake-parts. The outer function receives flake-level args; the inner function is the actual NixOS/home-manager module:

```nix
{ self, inputs, ... }: {
  flake.nixosModules.<name> = { pkgs, lib, config, ... }: {
    # NixOS module body
  };
}
```

For home-manager modules, use `flake.homeModules.<name>` instead:

```nix
{ self, ... }: {
  flake.homeModules.<name> = { pkgs, lib, config, ... }: {
    # home-manager module body
  };
}
```

Only include `self` / `inputs` / etc. in the outer args if they are actually used.

---

## Mixing `options` and `flake.*` in the Same File

**When a file declares `options` at the top level, all `flake.*` assignments must move into an explicit `config = {}` block.** Nix's module system requires this: a file cannot have both bare assignments and `options` declarations at the top level simultaneously.

Wrong — will cause `unsupported attribute 'flake'` error:

```nix
{ self, lib, ... }: {
  flake.homeModules.foo = { ... }: { };   # ← bare assignment

  options.flake.foo.bar = lib.mkOption { type = lib.types.str; };
}
```

Correct:

```nix
{ self, lib, ... }: {
  config.flake.homeModules.foo = { ... }: { };  # ← moved into config

  options.flake.foo.bar = lib.mkOption { type = lib.types.str; };
}
```

See `modules/module/shell-desktop/shell-desktop.nix` and `modules/module/theming/theming.nix` for real examples.

Files that only assign values and never declare `options` do **not** need the `config` wrapper — keep them as bare assignments.

---

## Root Module Pattern

The root module for a category:
- Imports every tool sub-module.
- Declares `options.<category>.programs.<tool>.enable` options.
- Uses `lib.mkIf` to conditionally activate each tool.

```nix
{ self, ... }: {
  flake.homeModules.<category> = { lib, ... }: {
    imports = [
      self.homeModules.<tool-a>
      self.homeModules.<tool-b>
    ];

    options.<category>.programs = {
      <tool-a>.enable = lib.mkEnableOption "<Tool A description>";
      <tool-b>.enable = lib.mkEnableOption "<Tool B description>";
    };
  };
}
```

The root module does **not** contain a `config` block — each tool sub-module is responsible for reading the option and gating itself.

---

## Tool Sub-Module Pattern

Each tool sub-module is minimal and focused on a single tool. It reads the enable option declared by the root module and gates itself with `lib.mkIf`:

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

For a single boolean assignment the inline form is also common:

```nix
programs.<tool>.enable = lib.mkIf config.<category>.programs.<tool>.enable true;
```

### Self-contained variant (theming style)

Some sub-modules (e.g. `theming-bat`, `theming-gtk`) declare their own option and gate a whole `config` block, instead of reading an option from the root module. Use this when the sub-module is self-sufficient and the root module doesn't need a central option list:

```nix
{ ... }: {
  flake.homeModules.<tool> = { lib, config, ... }: {
    options.<category>.<tool>.enable = lib.mkEnableOption "<description>";

    config = lib.mkIf config.<category>.<tool>.enable {
      programs.<tool>.enable = true;
      # ...
    };
  };
}
```

---

## System-Level Modules (NixOS modules with a `type` selector)

When a category has a system-level concept (compositor, shell) with swappable implementations, use a `nixosModule` with an enum option:

```nix
{ self, ... }: {
  flake.nixosModules.<category> = { config, lib, ... }: {
    imports = [ self.nixosModules.<implementation> ];

    options.<category>.type = lib.mkOption {
      type = lib.types.enum [ "<implementation>" ];
      default = "<implementation>";
    };

    config = lib.mkIf (config.<category>.type == "<implementation>") {
      # enable the implementation at the system level
    };
  };
}
```

These are imported in `home/zack/home.nix` (not inside `home-manager.users.zack`) and their `type` option is set there.

---

## Importing and Configuring in `home/zack/home.nix`

`home.nix` is the top-level user module. It wires everything together:

```nix
{ self, inputs, ... }: {
  flake.nixosModules.home-zack = { ... }: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      self.nixosModules.<system-level-category>  # e.g. compositor, shell
    ];

    # Set system-level options (outside home-manager block)
    <category>.type = "<implementation>";

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.zack = {
        imports = [
          self.homeModules.<category>       # root module
          self.homeModules.zacks-<tool>     # user override module
        ];

        # Enable specific tools via the root module's options
        <category>.programs.<tool>.enable = true;

        home.stateVersion = "25.11";  # do not change unless intentionally migrating
      };
    };
  };
}
```

---

## User Override Modules

User-specific configuration (personal extensions, keybindings, paths, etc.) lives in `home/<user>/config/<tool>.nix`. These modules are named `zacks-<tool>` and should be imported alongside the generic root module:

```nix
{ ... }: {
  flake.homeModules.zacks-<tool> = { ... }: {
    programs.<tool>.<user-specific-option> = ...;
  };
}
```

---

## Common Defaults Pattern

When settings need to be shared across users (or across common/zack configs), export them as a library value from `home/common/config/<tool>.nix`:

```nix
{ ... }: {
  flake.lib.<tool>.commonSettings = {
    # shared settings attrset
  };
}
```

User configs then reference this via `self.lib.<tool>.commonSettings`, using `lib.recursiveUpdate` to overlay user-specific values:

```nix
{ self, ... }: {
  flake.homeModules.zacks-<tool> = { lib, ... }: {
    programs.<tool>.settings = lib.recursiveUpdate self.lib.<tool>.commonSettings {
      # user-specific overrides
    };
  };
}
```

---

## Adding a New Program — Checklist

1. Create `modules/module/<category>/<tool>/<tool>.nix` — the tool sub-module. Gate its config with `lib.mkIf config.<category>.programs.<tool>.enable`.
2. Add `self.homeModules.<tool>` to the imports in `modules/module/<category>/<category>.nix`.
3. Add `<tool>.enable = lib.mkEnableOption "..."` to the root module's options.
4. Enable the tool in `modules/home/zack/home.nix` by setting `<category>.programs.<tool>.enable = true`.
5. If user-specific config is needed, create `modules/home/zack/config/<tool>.nix` and import it in `home.nix`.
6. If shared defaults are needed across users, add `modules/home/common/config/<tool>.nix` exporting `flake.lib.<tool>.commonSettings`.
7. **`git add` every new file** — `import-tree` uses git to enumerate files; unstaged files are invisible to Nix.
8. Rebuild: `sudo nixos-rebuild switch --flake .#framework`

---

## Adding a Completely New Category — Checklist

1. Create `modules/module/<category>/` directory.
2. Create `modules/module/<category>/<category>.nix` — root module with options and imports.
3. Create tool sub-modules under `modules/module/<category>/<tool>/<tool>.nix`.
4. In `home/zack/home.nix`, import `self.homeModules.<category>` and configure it.
5. Follow the existing checklist for each tool in the new category.

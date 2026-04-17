{ inputs, config, ... }:
let
  shell-desktop = config.flake.shell-desktop.program;
  cursor-name   = config.flake.theming.cursor.name;
  cursor-size   = config.flake.theming.cursor.size;
in {
  flake.nixosModules.niri = { pkgs, lib, config, ... }:
  let
    keyboard-layout  = config.keyboard.xkb.layout;
    keyboard-variant = config.keyboard.xkb.variant;
  in {
    options.niri.binds = lib.mkOption {
      type    = lib.types.attrs;
      default = {};
      description = "Niri key bindings.";
    };

    options.niri.extraConfig = lib.mkOption {
      type    = lib.types.lines;
      default = "";
      description = "Extra niri config appended verbatim.";
    };

    config.programs.niri = {
      enable = true;
      package = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;
        settings = {
          spawn-at-startup = [ shell-desktop ];

          xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

          input.keyboard.xkb = {
            layout  = keyboard-layout;
            variant = keyboard-variant;
          };

          cursor = {
            xcursor-theme = cursor-name;
            xcursor-size  = cursor-size;
          };

          extraConfig = config.niri.extraConfig + lib.concatMapStrings (mon:
            "output \"${mon.name}\" {\n"
            + lib.optionalString (mon.scale != 1.0) "  scale ${toString mon.scale}\n"
            + "  position x=${toString mon.position.x} y=${toString mon.position.y}\n"
            + "}\n"
          ) config.monitors;

          binds = config.niri.binds;
        };
      };
    };
  };
}

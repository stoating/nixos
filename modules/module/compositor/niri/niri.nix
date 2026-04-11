{ inputs, config, ... }:
let
  shell-program = config.flake.shell.program;
  cursor-name   = config.flake.theming.cursor.name;
  cursor-size   = config.flake.theming.cursor.size;
in {
  flake.nixosModules.niri = { pkgs, lib, config, ... }: {
    options.niri.binds = lib.mkOption {
      type    = lib.types.attrs;
      default = {};
      description = "Niri key bindings.";
    };

    config.programs.niri = {
      enable = true;
      package = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;
        settings = {
          spawn-at-startup = [ shell-program ];

          xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

          input.keyboard.xkb.layout = "de";

          cursor = {
            xcursor-theme = cursor-name;
            xcursor-size  = cursor-size;
          };

          extraConfig = lib.concatMapStrings (mon:
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

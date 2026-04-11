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

          extraConfig = ''
            output "DP-1" {
              position x=0 y=0
            }
            output "eDP-2" {
              scale 1.5
              position x=1920 y=0
            }
          '';

          binds = config.niri.binds;
        };
      };
    };
  };
}

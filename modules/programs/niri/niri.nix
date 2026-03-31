{ self, inputs, ... }: {
  flake.nixosModules.niri = { pkgs, lib, ... }: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.niri;
    };
  };

  perSystem = { pkgs, lib, self', ... }: {
    packages.niri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      settings = {
        spawn-at-startup = [
          (lib.getExe self'.packages.noctalia)
        ];

        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

        input.keyboard.xkb.layout = "de";

        layout = {
          gaps = 5;
          focus-ring = {
            active-color   = "#8fbcbb";
            inactive-color = "#2e3440";
            urgent-color   = "#bf616a";
          };
          border = {
            active-color   = "#8fbcbb";
            inactive-color = "#2e3440";
            urgent-color   = "#bf616a";
          };
          shadow.color = "#00000070";
          tab-indicator = {
            active-color   = "#8fbcbb";
            inactive-color = "#326766";
            urgent-color   = "#bf616a";
          };
          insert-hint.color = "#8fbcbb80";
        };

        extraConfig = ''
          cursor {
            xcursor-theme "GoogleDot-Black"
            xcursor-size 16
          }

          output "DP-1" {
            position x=0 y=0
          }
          output "eDP-2" {
            scale 1.5
            position x=1920 y=0
          }
        '';

        binds = {
          "Mod+Return".spawn-sh = lib.getExe pkgs.kitty;
          "Mod+Q".close-window = _: {};
          "Mod+S".spawn-sh = "${lib.getExe self'.packages.noctalia} ipc call launcher toggle";
        };
      };
    };
  };
}

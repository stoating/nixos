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

        layout.gaps = 5;

        extraConfig = ''
          cursor {
            xcursor-theme "Adwaita"
            xcursor-size 16
          }

          output "DP-1" {
            position x=0 y=0
          }
          output "eDP-2" {
            scale 2.0
            position x=1920 y=0
          }
        '';

        binds = {
          "Mod+Return".spawn-sh = lib.getExe pkgs.kitty;
          "Mod+Q".close-window = null;
          "Mod+S".spawn-sh = "${lib.getExe self'.packages.noctalia} ipc call launcher toggle";
        };
      };
    };
  };
}

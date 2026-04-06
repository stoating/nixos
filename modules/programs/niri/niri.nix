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
          # --- Compositor ---
          "Mod+F1".show-hotkey-overlay = _: {};
          "Mod+Tab".toggle-overview    = _: {};

          # --- Launchers ---
          "Mod+Return".spawn-sh = lib.getExe pkgs.ghostty;
          "Mod+G".spawn-sh      = lib.getExe pkgs.google-chrome;
          "Mod+S".spawn-sh      = "${lib.getExe self'.packages.noctalia} ipc call launcher toggle";
          "Mod+Y".spawn-sh      = lib.getExe pkgs.youtube-music;
          "Mod+C".spawn-sh      = lib.getExe pkgs.vscode;

          # --- Windows ---
          "Mod+Q".close-window               = _: {};
          "Mod+F".fullscreen-window          = _: {};
          "Mod+V".toggle-window-floating     = _: {};
          "Mod+Shift+V".switch-focus-between-floating-and-tiling = _: {};

          # --- Columns ---
          "Mod+Left".focus-column-left   = _: {};
          "Mod+Right".focus-column-right = _: {}; 
          "Mod+Shift+Left".move-column-left   = _: {};
          "Mod+Shift+Right".move-column-right = _: {};
          "Mod+R".switch-preset-column-width     = _: {};
          "Mod+W".maximize-column                = _: {};
          "Mod+BracketLeft".consume-or-expel-window-left   = _: {};
          "Mod+BracketRight".consume-or-expel-window-right = _: {};

          # --- Workspaces ---
          "Mod+Up".focus-workspace-up                    = _: {};
          "Mod+Down".focus-workspace-down                = _: {};
          "Mod+Shift+Up".move-column-to-workspace-up     = _: {};
          "Mod+Shift+Down".move-column-to-workspace-down = _: {};
        };
      };
    };
  };
}
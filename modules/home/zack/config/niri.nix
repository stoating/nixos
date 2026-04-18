{ self, config, ... }:
let
  launcher-command        = config.flake.shell-desktop.launcher-command;
  opacity-active   = self.lib.theme.opacity.window-active;
  opacity-inactive = self.lib.theme.opacity.window-inactive;

  opaque-apps = [
    "firefox"
    "discord"
    "chromium-browser"
    "pear-desktop"
    "io.podman_desktop.PodmanDesktop"
    "org.keepassxc.KeePassXC"
    "org.kde.kdenlive"
    "com.obsproject.Studio"
  ];
in {
  flake.nixosModules.zacks-niri = { pkgs, lib, ... }: {
    niri.layout = {
      focus-ring.off = _: {};
    };

    niri.extraConfig =
      ''
        window-rule {
          match is-active=true
          opacity ${opacity-active}
        }
        window-rule {
          match is-active=false
          opacity ${opacity-inactive}
        }
      '' +
      lib.concatMapStrings (app: ''
        window-rule {
          match app-id="${app}"
          opacity 1.0
        }
      '') opaque-apps;

    niri.binds = {
      # --- Compositor ---
      "Mod+F1".show-hotkey-overlay = _: {};
      "Mod+Tab".toggle-overview    = _: {};

      # --- Launchers ---
      "Mod+Return".spawn-sh = lib.getExe pkgs.ghostty;
      "Mod+G".spawn-sh      = lib.getExe pkgs.google-chrome;
      "Mod+S".spawn-sh      = launcher-command;
      "Mod+Y".spawn-sh      = lib.getExe pkgs.pear-desktop;
      "Mod+C".spawn-sh      = lib.getExe pkgs.vscode;

      # --- Windows ---
      "Mod+Q".close-window               = _: {};
      "Mod+F".fullscreen-window          = _: {};
      "Mod+V".toggle-window-floating     = _: {};
      "Mod+Shift+V".switch-focus-between-floating-and-tiling = _: {};

      # --- Columns ---
      "Mod+Left".focus-column-left   = _: {};
      "Mod+Right".focus-column-right = _: {};
      "Mod+Shift+Left".move-column-left-or-to-monitor-left   = _: {};
      "Mod+Shift+Right".move-column-right-or-to-monitor-right = _: {};
      "Mod+R".switch-preset-column-width     = _: {};
      "Mod+W".maximize-column                = _: {};
      "Mod+BracketLeft".consume-or-expel-window-left   = _: {};
      "Mod+BracketRight".consume-or-expel-window-right = _: {};

      # --- Wallpaper ---
      "Mod+Shift+W".spawn = [ "noctalia-shell" "ipc" "call" "wallpaper" "random" "" ];

      # --- Workspaces ---
      "Mod+Up".focus-workspace-up                    = _: {};
      "Mod+Down".focus-workspace-down                = _: {};
      "Mod+Shift+Up".move-column-to-workspace-up     = _: {};
      "Mod+Shift+Down".move-column-to-workspace-down = _: {};
    };
  };
}

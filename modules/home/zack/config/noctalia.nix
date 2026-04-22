{ self, ... }: {
  flake.homeModules.zacks-noctalia = { lib, pkgs, ... }: {
    programs.noctalia-shell.settings = lib.recursiveUpdate self.lib.noctalia.commonSettings {
      settingsVersion = 59;
      general.avatarImage = "/home/zack/pictures/profile/stoat.png";
      location.name      = "Stuttgart, DE";
      wallpaper.directory       = "/home/zack/pictures/wallpapers";
      wallpaper.automationEnabled = true;
      wallpaper.randomIntervalSec = 600;

      noctaliaPerformance.disableWallpaper = false;

      bar = {
        barType = "framed";
        density = "compact";
      };

      ui = {
        fontDefault      = "Adwaita Sans";
        fontFixed        = "Adwaita Mono";
        fontDefaultScale = 0.85;
        fontFixedScale   = 0.85;
      };

      appLauncher = {
        enableClipboardHistory = true;
      };

      colorSchemes = {
        predefinedScheme = self.lib.theme.noctalia;
      };

      hooks = {
        enabled = true;
        startup = "${pkgs.brightnessctl}/bin/brightnessctl set 60%";
      };

      sessionMenu = {
        largeButtonsStyle  = false;
        countdownDuration  = 5000;
      };
    };

    home.file.".cache/noctalia/wallpapers.json" = {
      text = builtins.toJSON {
        defaultWallpaper = "/home/zack/pictures/wallpapers/wallpaper.jpg";
        wallpapers = {
          "DP-1"  = "/home/zack/pictures/wallpapers/wallpaper.jpg";
          "eDP-2" = "/home/zack/pictures/wallpapers/wallpaper.jpg";
        };
      };
    };
  };
}

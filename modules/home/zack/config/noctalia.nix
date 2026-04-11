{ self, ... }: {
  flake.homeModules.zacks-noctalia = { lib, ... }: {
    programs.noctalia-shell.settings = lib.recursiveUpdate self.lib.noctalia.commonSettings {
      general.avatarImage = "/home/zack/images/profile/stoat.png";
      location.name      = "Stuttgart, DE";
      wallpaper.directory = "/home/zack/images/desktop";

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
        predefinedScheme = "Eldritch";
      };

      sessionMenu = {
        largeButtonsStyle  = true;
        largeButtonsLayout = "single-row";
      };
    };

    home.file.".cache/noctalia/wallpapers.json" = {
      text = builtins.toJSON {
        defaultWallpaper = "/home/zack/images/desktop/wallpaper.jpg";
        wallpapers = {
          "DP-1"  = "/home/zack/images/desktop/wallpaper.jpg";
          "eDP-2" = "/home/zack/images/desktop/wallpaper.jpg";
        };
      };
    };
  };
}

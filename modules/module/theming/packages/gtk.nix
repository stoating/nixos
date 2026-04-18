{ self, ... }: {
  flake.homeModules.theming-gtk = { pkgs, config, lib, ... }: {
    options.theming.gtk.enable = lib.mkEnableOption "GTK dark mode theming";

    config = lib.mkIf config.theming.gtk.enable {
      gtk = {
        enable = true;
        theme = {
          name    = self.lib.theme.gtk;
          package = {
            "Nordic"   = pkgs.nordic;
            "Ayu-Dark" = pkgs.ayu-theme-gtk;
          }.${self.lib.theme.gtk} or pkgs.nordic;
        };
        gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
        gtk4 = {
          extraConfig.gtk-application-prefer-dark-theme = 1;
          theme = null;
        };
      };
    };
  };
}

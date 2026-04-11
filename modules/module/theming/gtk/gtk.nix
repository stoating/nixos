{ ... }: {
  flake.homeModules.theming-gtk = { config, lib, ... }: {
    options.theming.gtk.enable = lib.mkEnableOption "GTK dark mode theming";

    config = lib.mkIf config.theming.gtk.enable {
      gtk = {
        enable = true;
        gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
        gtk4 = {
          extraConfig.gtk-application-prefer-dark-theme = 1;
          theme = null;
        };
      };
    };
  };
}

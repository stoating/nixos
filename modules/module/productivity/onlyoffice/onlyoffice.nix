{ ... }: {
  flake.homeModules.onlyoffice = { pkgs, lib, config, ... }: {
    home.packages = lib.mkIf config.productivity.programs.onlyoffice.enable [
      pkgs.onlyoffice-desktopeditors
    ];

    xdg.desktopEntries.onlyoffice-desktopeditors = lib.mkIf config.productivity.programs.onlyoffice.enable {
      name     = "ONLYOFFICE";
      exec     = "systemd-run --user --scope -- ${pkgs.onlyoffice-desktopeditors}/bin/onlyoffice-desktopeditors %U";
      icon     = "onlyoffice-desktopeditors";
      comment  = "Edit office documents";
      type     = "Application";
      terminal = false;
      categories = [ "Office" "WordProcessor" "Spreadsheet" "Presentation" ];
    };
  };
}

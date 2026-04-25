{ ... }: {
  flake.nixosModules.zacks-plymouth = { pkgs, ... }: {
    startup.plymouth = {
      theme = "angular_alt";
      themePackages = [
        (pkgs.adi1090x-plymouth-themes.override {
          selected_themes = [ "angular_alt" ];
        })
      ];
    };
  };
}

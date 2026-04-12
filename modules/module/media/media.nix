{ self, ... }: {
  flake.homeModules.media = { lib, ... }: {
    imports = [
      self.homeModules.asciinema
      self.homeModules.obs-studio
      self.homeModules.pear-desktop
    ];

    options.media.programs = {
      asciinema.enable   = lib.mkEnableOption "asciinema";
      obs-studio.enable  = lib.mkEnableOption "OBS Studio";
      pear-desktop.enable = lib.mkEnableOption "Pear Desktop";
    };
  };
}

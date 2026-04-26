{ self, ... }: {
  flake.homeModules.monitoring = { lib, ... }: {
    imports = [
      self.homeModules.btop
      self.homeModules.bandwhich
      self.homeModules.gping
      self.homeModules.fastfetch
    ];

    options.monitoring.programs = {
      btop.enable       = lib.mkEnableOption "btop";
      bandwhich.enable  = lib.mkEnableOption "bandwhich";
      gping.enable      = lib.mkEnableOption "gping";
      fastfetch.enable  = lib.mkEnableOption "fastfetch";
    };
  };
}

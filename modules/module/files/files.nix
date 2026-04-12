{ self, ... }: {
  flake.homeModules.files = { lib, ... }: {
    imports = [
      self.homeModules.fd
      self.homeModules.ripgrep
      self.homeModules.yazi
      self.homeModules.mc
    ];

    options.files.programs = {
      fd.enable      = lib.mkEnableOption "fd";
      ripgrep.enable = lib.mkEnableOption "ripgrep";
      yazi.enable    = lib.mkEnableOption "yazi";
      mc.enable      = lib.mkEnableOption "Midnight Commander";
    };
  };
}

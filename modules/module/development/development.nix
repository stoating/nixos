{ self, ... }: {
  flake.homeModules.development = { lib, ... }: {
    imports = [
      self.homeModules.git
      self.homeModules.gh
      self.homeModules.lazygit
      self.homeModules.direnv
    ];

    options.development.programs = {
      git.enable     = lib.mkEnableOption "Git";
      gh.enable      = lib.mkEnableOption "GitHub CLI";
      lazygit.enable = lib.mkEnableOption "Lazygit";
      direnv.enable  = lib.mkEnableOption "direnv";
    };
  };
}

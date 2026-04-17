{ self, ... }: {
  flake.homeModules.development = { lib, ... }: {
    imports = [
      self.homeModules.git
      self.homeModules.gh
      self.homeModules.lazygit
      self.homeModules.direnv
      self.homeModules.delta
      self.homeModules.python
    ];

    options.development.programs = {
      git.enable     = lib.mkEnableOption "Git";
      gh.enable      = lib.mkEnableOption "GitHub CLI";
      lazygit.enable = lib.mkEnableOption "Lazygit";
      direnv.enable  = lib.mkEnableOption "direnv";
      delta.enable   = lib.mkEnableOption "delta";
      python.enable  = lib.mkEnableOption "Python 3";
    };
  };
}

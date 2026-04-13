{ self, ... }: {
  flake.homeModules.shell-cli = { lib, ... }: {
    imports = [
      self.homeModules.zsh
      self.homeModules.fish
      self.homeModules.nushell
    ];

    options.shell-cli.programs = {
      zsh.enable      = lib.mkEnableOption "zsh";
      fish.enable     = lib.mkEnableOption "fish desktop";
      nushell.enable  = lib.mkEnableOption "nushell";
    };
  };
}

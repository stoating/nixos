{ ... }: {
  flake.homeModules.direnv = { lib, config, ... }: {
    programs.direnv = lib.mkIf config.development.programs.direnv.enable {
      enable = true;
      enableZshIntegration = true;
    };
  };
}

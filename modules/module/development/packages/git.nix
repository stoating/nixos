{ ... }: {
  flake.homeModules.git = { lib, config, ... }: {
    programs.git = lib.mkIf config.development.programs.git.enable {
      enable = true;
    };
  };
}

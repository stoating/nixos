{ ... }: {
  flake.homeModules.git = { lib, config, ... }: {
    programs.git.enable = lib.mkIf config.development.programs.git.enable true;
  };
}

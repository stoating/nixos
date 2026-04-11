{ ... }: {
  flake.homeModules.gh = { lib, config, ... }: {
    programs.gh.enable = lib.mkIf config.development.programs.gh.enable true;
  };
}

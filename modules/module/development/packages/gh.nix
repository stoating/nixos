{ ... }: {
  flake.homeModules.gh = { lib, config, ... }: {
    programs.gh = lib.mkIf config.development.programs.gh.enable {
      enable = true;
    };
  };
}

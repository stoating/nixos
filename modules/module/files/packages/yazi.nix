{ ... }: {
  flake.homeModules.yazi = { lib, config, ... }: {
    programs.yazi.enable = lib.mkIf config.files.programs.yazi.enable true;
  };
}

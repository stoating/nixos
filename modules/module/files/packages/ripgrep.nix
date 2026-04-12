{ ... }: {
  flake.homeModules.ripgrep = { lib, config, ... }: {
    programs.ripgrep.enable = lib.mkIf config.files.programs.ripgrep.enable true;
  };
}

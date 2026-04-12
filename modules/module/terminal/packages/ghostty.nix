{ ... }: {
  flake.homeModules.ghostty = { lib, config, ... }: {
    programs.ghostty.enable = lib.mkIf config.terminal.programs.ghostty.enable true;
  };
}

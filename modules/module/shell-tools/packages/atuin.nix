{ ... }: {
  flake.homeModules.atuin = { lib, config, ... }: {
    programs.atuin.enable = lib.mkIf config.shell-tools.programs.atuin.enable true;
  };
}

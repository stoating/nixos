{ ... }: {
  flake.homeModules.atuin = { lib, config, ... }: {
    programs.atuin = lib.mkIf config.shell-tools.programs.atuin.enable {
      enable = true;
    };
  };
}

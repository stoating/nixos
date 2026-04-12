{ ... }: {
  flake.homeModules.navi = { lib, config, ... }: {
    programs.navi = lib.mkIf config.shell-tools.programs.navi.enable {
      enable = true;
      enableZshIntegration = true;
    };
  };
}

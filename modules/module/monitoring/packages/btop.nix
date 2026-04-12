{ ... }: {
  flake.homeModules.btop = { lib, config, ... }: {
    programs.btop = lib.mkIf config.monitoring.programs.btop.enable {
      enable = true;
    };
  };
}

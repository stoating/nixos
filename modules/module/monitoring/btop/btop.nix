{ ... }: {
  flake.homeModules.btop = { pkgs, lib, config, ... }: {
    home.packages = lib.mkIf config.monitoring.programs.btop.enable [ pkgs.btop ];
  };
}

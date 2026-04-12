{ ... }: {
  flake.homeModules.bandwhich = { pkgs, lib, config, ... }: {
    home.packages = lib.mkIf config.monitoring.programs.bandwhich.enable [ pkgs.bandwhich ];
  };
}

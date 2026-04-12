{ ... }: {
  flake.homeModules.gping = { pkgs, lib, config, ... }: {
    home.packages = lib.mkIf config.monitoring.programs.gping.enable [ pkgs.gping ];
  };
}

{ ... }: {
  flake.homeModules.fastfetch = { pkgs, lib, config, ... }: {
    home.packages = lib.mkIf config.monitoring.programs.fastfetch.enable [ pkgs.fastfetch ];
  };
}

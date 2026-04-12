{ ... }: {
  flake.homeModules.pear-desktop = { pkgs, lib, config, ... }: {
    home.packages = lib.mkIf config.media.programs.pear-desktop.enable [ pkgs.pear-desktop ];
  };
}

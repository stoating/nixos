{ ... }: {
  flake.homeModules.wl-clipboard = { pkgs, lib, config, ... }: {
    home.packages = lib.mkIf config.media.programs.wl-clipboard.enable [ pkgs.wl-clipboard ];
  };
}

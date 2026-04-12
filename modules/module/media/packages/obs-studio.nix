{ ... }: {
  flake.homeModules.obs-studio = { pkgs, lib, config, ... }: {
    home.packages = lib.mkIf config.media.programs.obs-studio.enable [ pkgs.obs-studio ];
  };
}

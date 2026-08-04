{ ... }: {
  flake.homeModules.rapid-photo-downloader = { pkgs, lib, config, ... }: {
    home.packages = lib.mkIf config.media.programs.rapid-photo-downloader.enable [
      pkgs.rapid-photo-downloader
    ];
  };
}

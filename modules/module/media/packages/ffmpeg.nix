{ ... }: {
  flake.homeModules.ffmpeg = { pkgs, lib, config, ... }: {
    home.packages = lib.mkIf config.media.programs.ffmpeg.enable [
      pkgs.ffmpeg
    ];
  };
}

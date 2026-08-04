{ ... }: {
  flake.homeModules.mpv = { lib, config, ... }: {
    programs.mpv = lib.mkIf config.media.programs.mpv.enable {
      enable = true;
    };
  };
}

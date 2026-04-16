{ ... }: {
  flake.homeModules.asciinema = { lib, config, ... }: {
    programs.asciinema = lib.mkIf config.media.programs.asciinema.enable {
      enable = true;
    };
  };
}

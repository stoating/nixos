{ ... }: {
  flake.homeModules.asciinema = { pkgs, lib, config, ... }: {
    home.packages = lib.mkIf config.media.programs.asciinema.enable [ pkgs.asciinema_3 ];
  };
}

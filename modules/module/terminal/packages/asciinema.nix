{ ... }: {
  flake.homeModules.asciinema = { pkgs, lib, config, ... }: {
    home.packages = lib.mkIf config.terminal.programs.asciinema.enable [ pkgs.asciinema_3 ];
  };
}

{ ... }: {
  flake.homeModules.discord = { pkgs, lib, config, ... }: {
    home.packages = lib.mkIf config.media.programs.discord.enable [ pkgs.discord ];
  };
}

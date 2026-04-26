{ ... }: {
  flake.homeModules.grim = { pkgs, lib, config, ... }: {
    home.packages = lib.mkIf config.media.programs.grim.enable [ pkgs.grim ];
  };
}

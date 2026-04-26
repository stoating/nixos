{ ... }: {
  flake.homeModules.slurp = { pkgs, lib, config, ... }: {
    home.packages = lib.mkIf config.media.programs.slurp.enable [ pkgs.slurp ];
  };
}

{ ... }: {
  flake.homeModules.mc = { pkgs, lib, config, ... }: {
    home.packages = lib.mkIf config.files.programs.mc.enable [ pkgs.mc ];
  };
}

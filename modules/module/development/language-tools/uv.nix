{ ... }: {
  flake.homeModules.uv = { pkgs, lib, config, ... }: {
    home.packages = lib.mkIf config.development."language-tools".uv.enable [
      pkgs.uv
    ];
  };
}

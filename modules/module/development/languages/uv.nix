{ ... }: {
  flake.homeModules.uv = { pkgs, lib, config, ... }: {
    home.packages = lib.mkIf config.development.languages.uv.enable [
      pkgs.uv
    ];
  };
}

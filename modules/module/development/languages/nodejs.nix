{ ... }: {
  flake.homeModules.nodejs = { pkgs, lib, config, ... }: {
    home.packages = lib.mkIf config.development.languages.nodejs.enable [
      pkgs.nodejs
    ];
  };
}

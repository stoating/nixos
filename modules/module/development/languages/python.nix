{ ... }: {
  flake.homeModules.python = { pkgs, lib, config, ... }: {
    home.packages = lib.mkIf config.development.languages.python.enable [
      pkgs.python3
    ];
  };
}

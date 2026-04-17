{ ... }: {
  flake.homeModules.python = { pkgs, lib, config, ... }: {
    home.packages = lib.mkIf config.development.programs.python.enable [
      pkgs.python3
    ];
  };
}

{ ... }: {
  flake.homeModules.devenv = { pkgs, lib, config, ... }: {
    home.packages = lib.mkIf config.development.programs.devenv.enable [
      pkgs.devenv
    ];
  };
}

{ ... }: {
  flake.homeModules.wpsoffice = { pkgs, lib, config, ... }: {
    home.packages = lib.mkIf config.productivity.programs.wpsoffice.enable [
      pkgs.wpsoffice
    ];
  };
}

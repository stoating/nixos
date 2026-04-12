{ ... }: {
  flake.homeModules.libreoffice = { pkgs, lib, config, ... }: {
    home.packages = lib.mkIf config.productivity.programs.libreoffice.enable [
      pkgs.libreoffice
    ];
  };
}

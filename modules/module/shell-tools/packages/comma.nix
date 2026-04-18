{ ... }: {
  flake.homeModules.comma = { pkgs, lib, config, ... }: {
    home.packages = lib.mkIf config.shell-tools.programs.comma.enable [
      pkgs.comma
    ];
  };
}

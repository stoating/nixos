{ ... }: {
  flake.homeModules.atuin-desktop = { pkgs, lib, config, ... }: {
    home.packages = lib.mkIf config.shell-tools.programs.atuin-desktop.enable [ pkgs.atuin-desktop ];
  };
}

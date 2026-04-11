{ ... }: {
  flake.homeModules.podman-desktop = { pkgs, lib, config, ... }: {
    home.packages = lib.mkIf config.containers.programs.podman-desktop.enable [
      pkgs.podman-desktop
    ];
  };
}

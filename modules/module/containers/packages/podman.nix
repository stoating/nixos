{ ... }: {
  flake.homeModules.podman = { pkgs, lib, config, ... }: {
    home.packages = lib.mkIf config.containers.programs.podman.enable [
      pkgs.podman
    ];
  };
}

{ ... }: {
  flake.homeModules.docker = { pkgs, lib, config, ... }: {
    home.packages = lib.mkIf config.containers.programs.docker.enable [
      pkgs.docker
    ];
  };
}

{ self, ... }: {
  flake.homeModules.containers = { lib, ... }: {
    imports = [
      self.homeModules.docker
      self.homeModules.podman
      self.homeModules.podman-desktop
    ];

    options.containers.programs = {
      docker.enable         = lib.mkEnableOption "Docker";
      podman.enable         = lib.mkEnableOption "Podman";
      podman-desktop.enable = lib.mkEnableOption "Podman Desktop";
    };
  };
}

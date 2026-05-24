{ self, ... }: {
  flake.nixosModules.networking = { lib, ... }: {
    imports = [
      self.nixosModules.tailscale
    ];

    options.networking.programs = {
      tailscale.enable = lib.mkEnableOption "tailscale";
    };
  };
}

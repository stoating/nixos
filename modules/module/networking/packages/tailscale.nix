{ ... }: {
  flake.nixosModules.tailscale = { lib, config, ... }: {
    config = lib.mkIf config.networking.programs.tailscale.enable {
      services.tailscale = {
        enable = true;
      };
    };
  };
}

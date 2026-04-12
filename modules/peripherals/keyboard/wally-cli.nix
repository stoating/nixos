{ ... }: {
  flake.nixosModules.wally-cli = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.wally-cli ];
  };
}

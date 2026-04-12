{ ... }: {
  flake.nixosModules.nushell = { pkgs, config, lib, ... }: {
    config = lib.mkIf (config.shell-cli.type == "nushell") {
      environment.shells = [ pkgs.nushell ];
    };
  };
}

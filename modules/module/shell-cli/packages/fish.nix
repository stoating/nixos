{ ... }: {
  flake.nixosModules.fish = { config, lib, ... }: {
    config = lib.mkIf (config.shell-cli.type == "fish") {
      programs.fish.enable = true;
    };
  };
}

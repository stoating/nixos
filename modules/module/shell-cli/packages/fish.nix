{ ... }: {
  flake.homeModules.fish = { config, lib, ... }: {
    programs.fish = lib.mkIf config.shell-cli.programs.fish.enable {
      enable = true;
    };
  };
}

{ ... }: {
  flake.homeModules.nushell = { config, lib, ... }: {
    programs.nushell = lib.mkIf config.shell-cli.programs.nushell.enable {
      enable = true;
    };
  };
}

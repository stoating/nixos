{ ... }: {
  flake.homeModules.tldr = { lib, config, ... }: {
    programs.tealdeer = lib.mkIf config.shell-tools.programs.tldr.enable {
      enable = true;
    };
  };
}

{ ... }: {
  flake.homeModules.tmux = { lib, config, ... }: {
    programs.tmux = lib.mkIf config.terminal.programs.tmux.enable {
      enable = true;
    };
  };
}

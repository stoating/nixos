{ ... }: {
  flake.homeModules.tmux = { lib, config, ... }: {
    programs.tmux.enable = lib.mkIf config.terminal.programs.tmux.enable true;
  };
}

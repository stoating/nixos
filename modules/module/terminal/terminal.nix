{ self, ... }: {
  flake.homeModules.terminal = { lib, ... }: {
    imports = [
      self.homeModules.tmux
      self.homeModules.ghostty
    ];

    options.terminal.programs = {
      tmux.enable    = lib.mkEnableOption "tmux";
      ghostty.enable = lib.mkEnableOption "Ghostty";
    };
  };
}

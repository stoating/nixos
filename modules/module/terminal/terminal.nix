{ self, ... }: {
  flake.homeModules.terminal = { lib, ... }: {
    imports = [
      self.homeModules.tmux
      self.homeModules.vim
      self.homeModules.asciinema
    ];

    options.terminal.programs = {
      tmux.enable      = lib.mkEnableOption "tmux";
      vim.enable       = lib.mkEnableOption "vim";
      asciinema.enable = lib.mkEnableOption "asciinema";
    };
  };
}

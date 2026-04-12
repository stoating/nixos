{ ... }: {
  flake.homeModules.vim = { lib, config, ... }: {
    programs.vim.enable = lib.mkIf config.terminal.programs.vim.enable true;
  };
}

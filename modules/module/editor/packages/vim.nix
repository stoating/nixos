{ ... }: {
  flake.homeModules.vim = { lib, config, ... }: {
    programs.vim.enable = lib.mkIf config.editor.programs.vim.enable true;
  };
}

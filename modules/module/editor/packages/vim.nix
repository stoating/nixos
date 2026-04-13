{ ... }: {
  flake.homeModules.vim = { lib, config, ... }: {
    programs.vim = lib.mkIf config.editor.programs.vim.enable {
      enable = true;
    };
  };
}

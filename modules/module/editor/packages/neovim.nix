{ ... }: {
  flake.homeModules.neovim = { lib, config, ... }: {
    programs.neovim = lib.mkIf config.editor.programs.neovim.enable {
      enable      = true;
      withRuby    = false;
      withPython3 = false;
    };
  };
}

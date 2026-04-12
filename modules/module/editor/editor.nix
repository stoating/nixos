{ self, ... }: {
  flake.homeModules.editor = { lib, ... }: {
    imports = [
      self.homeModules.vscode
      self.homeModules.vim
      self.homeModules.neovim
      self.homeModules.emacs
    ];

    options.editor.programs = {
      vscode.enable  = lib.mkEnableOption "Visual Studio Code";
      vim.enable     = lib.mkEnableOption "Vim";
      neovim.enable  = lib.mkEnableOption "Neovim";
      emacs.enable   = lib.mkEnableOption "Emacs";
    };
  };
}

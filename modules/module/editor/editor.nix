{ self, ... }: {
  flake.homeModules.editor = { lib, ... }: {
    imports = [
      self.homeModules.vscode
      self.homeModules.vim
    ];

    options.editor.programs = {
      vscode.enable = lib.mkEnableOption "Visual Studio Code";
      vim.enable    = lib.mkEnableOption "Vim";
    };
  };
}

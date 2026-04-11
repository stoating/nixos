{ self, lib, ... }: {
  flake.homeModules.ide = { config, lib, ... }: {
    imports = [
      self.homeModules.vscode
    ];

    options.ide.programs = {
      vscode.enable = lib.mkEnableOption "Visual Studio Code";
    };

    config = lib.mkMerge [
      (lib.mkIf config.ide.programs.vscode.enable {
        programs.vscode.enable = true;
      })
    ];
  };
}

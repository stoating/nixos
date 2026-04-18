{ ... }: {
  flake.homeModules.vscode = { pkgs, lib, config, ... }: {
    programs.vscode = lib.mkIf config.editor.programs.vscode.enable {
      enable = true;
      mutableExtensionsDir = false;
      package = pkgs.vscode;
    };

    home.sessionVariables = lib.mkIf config.editor.programs.vscode.enable {
      NIXOS_OZONE_WL = "1";
    };
  };
}

{ inputs, ... }: {
  flake.homeModules.vscode = { pkgs, lib, config, osConfig ? {}, ... }: {
    programs.vscode = lib.mkIf config.editor.programs.vscode.enable {
      enable = true;
      mutableExtensionsDir = false;
      package = (import inputs.vscode {
        inherit (pkgs.stdenv.hostPlatform) system;
        config.allowUnfree = true;
      }).vscode;
    };

    home.sessionVariables = lib.mkIf (osConfig.desktop.session.type == "wayland") {
      NIXOS_OZONE_WL = "1";
    };
  };
}

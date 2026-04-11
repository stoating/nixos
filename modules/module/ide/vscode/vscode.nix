{ inputs, ... }: {
  flake.homeModules.vscode = { pkgs, lib, osConfig ? {}, ... }: {
    programs.vscode = {
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
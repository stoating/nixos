{ inputs, ... }: {
  flake.program.vscode = { pkgs, ... }: {
    programs.vscode = {
      enable = true;
      mutableExtensionsDir = false;
      package = (import inputs.vscode {
        inherit (pkgs.stdenv.hostPlatform) system;
        config.allowUnfree = true;
      }).vscode;
    };
  };
}
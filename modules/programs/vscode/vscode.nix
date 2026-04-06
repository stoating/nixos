{ ... }: {
  flake.program.vscode = { ... }: {
    programs.vscode = {
      enable = true;
      mutableExtensionsDir = false;
    };
  };
}
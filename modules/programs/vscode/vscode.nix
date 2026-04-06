{ ... }: {
  flake.program.vscode = { pkgs, ... }: {
    programs.vscode = {
      enable = true;
      mutableExtensionsDir = false;
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          github.copilot
          github.copilot-chat
          bbenoist.nix
        ];
        userSettings = {
          "explorer.confirmDelete" = true;
          "explorer.confirmDragAndDrop" = true;
          "github.copilot.nextEditSuggestions.enabled" = true;
          "git.enableSmartCommit" = true;
          "git.autofetch" = true;
        };
      };
    };
  };
}
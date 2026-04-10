{ ... }: {
  flake.homes.zack.vscode = { pkgs, ... }: {
    programs.vscode.profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        bbenoist.nix
        github.copilot-chat
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
}

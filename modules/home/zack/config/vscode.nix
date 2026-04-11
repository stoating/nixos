{ ... }: {
  flake.homeModules.zacks-vscode = { pkgs, ... }: {
    home.packages = with pkgs; [
      nixd
      nixfmt
    ];

    programs.vscode.profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        bbenoist.nix
        github.copilot-chat
        jnoortheen.nix-ide
      ];
      userSettings = {
        "explorer.confirmDelete" = true;
        "explorer.confirmDragAndDrop" = true;
        "github.copilot.nextEditSuggestions.enabled" = true;
        "git.enableSmartCommit" = true;
        "git.autofetch" = true;
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";
        "nix.serverSettings" = {
          "nixd" = {
            "formatting" = {
              "command" = [ "nixfmt" ];
            };
            "options" = {
              "nixos" = {
                "expr" = "(builtins.getFlake \"/home/zack/nixos\").nixosConfigurations.framework.options";
              };
            };
          };
        };
      };
    };
  };
}

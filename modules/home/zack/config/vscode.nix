{ self, ... }: {
  flake.homeModules.zacks-vscode = { pkgs, ... }:
  let
    theme = self.lib.theme;
  in {
    home.packages = with pkgs; [
      nixd
      nixfmt
    ];

    programs.vscode.profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        arcticicestudio.nord-visual-studio-code
        (anthropic.claude-code.overrideAttrs (_: {
          src = pkgs.fetchurl {
            name = "anthropic-claude-code.vsix";
            url = "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/anthropic/vsextensions/claude-code/2.1.92/vspackage";
            hash = "sha256-f+6xXZVb5sYrmrH7eoon6/QoQaTnBuTnb+YnvszqyKA=";
          };
        }))
        bbenoist.nix
        github.copilot-chat
        jnoortheen.nix-ide
      ];
      userSettings = {
        "workbench.colorTheme" = theme.vscode;
        "explorer.confirmDelete" = true;
        "explorer.confirmDragAndDrop" = true;
        "github.copilot.nextEditSuggestions.enabled" = true;
        "git.enableSmartCommit" = true;
        "git.autofetch" = true;
        "terminal.integrated.defaultProfile.linux" = "zsh";
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

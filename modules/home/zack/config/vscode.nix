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
        ({
          "Nord" = arcticicestudio.nord-visual-studio-code;
          "Ayu"  = teabyii.ayu;
        }.${theme.name})
        (anthropic.claude-code.overrideAttrs (_: {
          src = pkgs.fetchurl {
            name = "anthropic-claude-code.vsix";
            url = "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/anthropic/vsextensions/claude-code/2.1.114/vspackage";
            hash = "sha256-rcEbeYsyhbhh5wj6Mo3kz2+K3uZe5XMBKpwmSaB9Pgc=";
            curlOptsList = [ "--compressed" ];
          };
        }))
        (pkgs.vscode-utils.extensionFromVscodeMarketplace {
          publisher = "djblue";
          name      = "portal";
          version   = "0.63.1";
          sha256    = "1sq6dx9an0f4w8cfl6irjldvwgc7df2ly7n4wdbj53x09ykiaf6b";
        })
        (pkgs.vscode-utils.extensionFromVscodeMarketplace {
          publisher = "medo64";
          name      = "render-crlf";
          version   = "1.9.4";
          sha256    = "0n84jw2ljv1h9dl8cfmywmm9zz3j5lhzxhb280pip31psdf9ik4q";
        })
        bbenoist.nix
        betterthantomorrow.calva
        davidanson.vscode-markdownlint
        esbenp.prettier-vscode
        github.copilot-chat
        irongeek.vscode-env
        jnoortheen.nix-ide
        redhat.vscode-yaml
        shardulm94.trailing-spaces
        zainchen.json
      ];
      userSettings = {
        "workbench.colorTheme" = theme.vscode;
        "explorer.confirmDelete" = true;
        "explorer.confirmDragAndDrop" = true;
        "github.copilot.nextEditSuggestions.enabled" = true;
        "git.enableSmartCommit" = true;
        "git.autofetch" = true;
        "editor.renderWhitespace" = "all";
        "editor.renderControlCharacters" = true;
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

{ self, ... }: {
  flake.homeModules.zacks-vscode = { pkgs, ... }:
  let
    theme = self.lib.theme;
  in {
    home.packages = with pkgs; [
      fira-code
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
            hash = "sha256-TfVradC9ZjfLBp8QvZ0AptCS9j2ogzSlsRXxksp+N9I=";
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
        (pkgs.vscode-utils.extensionFromVscodeMarketplace {
          publisher = "mohsen1";
          name      = "prettify-json";
          version   = "0.0.3";
          sha256    = "1spj01dpfggfchwly3iyfm2ak618q2wqd90qx5ndvkj3a7x6rxwn";
        })
        bbenoist.nix
        betterthantomorrow.calva
        davidanson.vscode-markdownlint
        esbenp.prettier-vscode
        github.copilot-chat
        github.vscode-github-actions
        irongeek.vscode-env
        jnoortheen.nix-ide
        redhat.vscode-yaml
        shardulm94.trailing-spaces
        tamasfe.even-better-toml
        zainchen.json
      ];
      keybindings = [
        {
          key = "alt+t alt+a";
          command = "calva.runAllTests";
        }
        {
          key = "alt+i";
          command = "calva.runCustomREPLCommand";
          when = "calva:connected && calva:keybindingsEnabled && editorLangId == 'clojure'";
        }
        {
          key = "alt+t alt+c";
          command = "calva.runNamespaceTests";
          when = "calva:connected && calva:keybindingsEnabled";
        }
        {
          key = "ctrl+shift+alt+r";
          command = "paredit.barfSexpForward";
          when = "calva:keybindingsEnabled && editorTextFocus && editorLangId == 'clojure' && paredit:keyMap =~ /original|strict/";
        }
        {
          key = "ctrl+shift+alt+e";
          command = "paredit.slurpSexpForward";
          when = "calva:keybindingsEnabled && editorTextFocus && editorLangId == 'clojure' && paredit:keyMap =~ /original|strict/";
        }
        {
          key = "alt+left";
          command = "workbench.action.navigateBack";
        }
        {
          key = "alt+right";
          command = "workbench.action.navigateForward";
        }
      ];
      userSettings = {
        "workbench.colorTheme" = theme.vscode;
        "explorer.confirmDelete" = true;
        "explorer.confirmDragAndDrop" = true;
        "github.copilot.nextEditSuggestions.enabled" = true;
        "git.enableSmartCommit" = true;
        "git.autofetch" = true;
        "editor.fontFamily" = "Fira Code";
        "editor.fontWeight" = "475";
        "editor.fontLigatures" = true;
        "editor.indentSize" = "tabSize";
        "editor.inlineSuggest.enabled" = true;
        "editor.renderWhitespace" = "all";
        "editor.renderControlCharacters" = true;
        "editor.rulers" = [ 80 120 ];
        "terminal.integrated.defaultProfile.linux" = "zsh";
        "markdownlint.config" = {
          "MD022" = false;
          "MD031" = false;
          "MD032" = false;
          "MD040" = false;
          "MD060" = false;
        };
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

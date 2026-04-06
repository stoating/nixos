{ self, inputs, ... }: {

  flake.nixosModules.home-zack = { pkgs, lib, ... }: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.zack = {
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

        home.stateVersion = "25.11";
      };
    };
  };

}

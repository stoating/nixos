{ self, inputs, ... }: {

  flake.nixosModules.home-zack = { pkgs, lib, ... }: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.zack = {
        imports = [
          self.module.browser
          self.module.ide
          self.module.passwords
          self.homes.zack.vscode
          self.homes.zack.chromium
        ];

        browser.programs = {
          chrome.enable = true;
          chromium.enable = true;
          firefox.enable = true;
        };

        ide.programs = {
          vscode.enable = true;
        };

        passwords.programs = {
          keepassxc.enable = true;
        };

        home.stateVersion = "25.11";
      };
    };
  };

}

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
          self.program.vscode
          self.program.keepassxc
          self.module.browser
          self.homes.zack.vscode
          self.homes.zack.chromium
        ];

        browser.programs = {
          chrome.enable = true;
          chromium.enable = true;
          firefox.enable = true;
        };

        home.stateVersion = "25.11";
      };
    };
  };

}

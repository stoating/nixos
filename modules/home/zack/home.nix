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
          self.module.browser
        ];

        browser.programs = {
          chromium.enable = true;
          firefox.enable = true;
        };

        home.stateVersion = "25.11";
      };
    };
  };

}

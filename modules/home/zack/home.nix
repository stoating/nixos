{ self, inputs, ... }: {

  flake.nixosModules.home-zack = { ... }: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      self.nixosModules.compositor
      self.nixosModules.shell
    ];

    # User chooses compositor
    compositor.type = "niri";

    # User chooses shell
    shell.type = "noctalia";

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.zack = {
        imports = [
          self.homeModules.browser
          self.homeModules.ide
          self.homeModules.passwords
          self.homeModules.theming
          self.homeModules.zacks-vscode
          self.homeModules.zacks-chromium
          self.homeModules.zacks-noctalia
          self.homeModules.zacks-cursor
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

        theming.gtk.enable = true;

        home.stateVersion = "25.11";
      };
    };
  };
}

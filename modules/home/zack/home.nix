{ self, inputs, ... }: {

  flake.nixosModules.home-zack = { ... }: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      self.nixosModules.compositor
      self.nixosModules.shell
      self.nixosModules.zacks-niri
      self.nixosModules.zacks-monitors
      self.nixosModules.zacks-keyboard
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
          self.homeModules.containers
          self.homeModules.development
          self.homeModules.ide
          self.homeModules.passwords
          self.homeModules.productivity
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

        containers.programs = {
          docker.enable         = true;
          podman.enable         = true;
          podman-desktop.enable = true;
        };

        development.programs = {
          git.enable     = true;
          gh.enable      = true;
          lazygit.enable = true;
          direnv.enable  = true;
        };

        ide.programs = {
          vscode.enable = true;
        };

        passwords.programs = {
          keepassxc.enable = true;
        };

        productivity.programs = {
          libreoffice.enable = true;
          onlyoffice.enable  = true;
          wpsoffice.enable   = true;
        };

        theming.gtk.enable = true;

        home.stateVersion = "25.11";
      };
    };
  };
}

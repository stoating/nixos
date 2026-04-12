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
          self.homeModules.data
          self.homeModules.development
          self.homeModules.files
          self.homeModules.ide
          self.homeModules.monitoring
          self.homeModules.passwords
          self.homeModules.productivity
          self.homeModules.shell-tools
          self.homeModules.terminal
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

        data.programs = {
          jq.enable = true;
          yq.enable = true;
        };

        files.programs = {
          fd.enable      = true;
          ripgrep.enable = true;
          yazi.enable    = true;
          mc.enable      = true;
        };

        monitoring.programs = {
          btop.enable      = true;
          bandwhich.enable = true;
          gping.enable     = true;
        };

        shell-tools.programs = {
          atuin.enable         = true;
          atuin-desktop.enable = true;
          fzf.enable           = true;
          zoxide.enable        = true;
          navi.enable          = true;
          tldr.enable          = true;
        };

        terminal.programs = {
          tmux.enable      = true;
          vim.enable       = true;
          asciinema.enable = true;
        };

        theming.gtk.enable = true;
        theming.bat.enable = true;

        home.stateVersion = "25.11";
      };
    };
  };
}

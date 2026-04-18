{ self, inputs, ... }: {

  # Generic admin home for any VPS host.
  # Wire up in a host configuration like:
  #
  #   imports = [ self.nixosModules.home-vps-admin ];
  #   home-manager.users.admin.home.stateVersion = "25.11";

  flake.nixosModules.home-vps-admin = { ... }: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];

    home-manager = {
      useGlobalPkgs   = true;
      useUserPackages = true;
      users.admin = {
        imports = [
          self.homeModules.development
          self.homeModules.files
          self.homeModules.monitoring
          self.homeModules.shell-cli
          self.homeModules.shell-tools
          self.homeModules.terminal
          self.homeModules.zacks-zsh
          self.homeModules.zacks-fzf
        ];

        development.programs = {
          git.enable    = true;
          gh.enable     = true;
          direnv.enable = true;
          delta.enable  = true;
        };

        development.languages = {
          clojure.enable   = true;
          nodejs.enable    = true;
          jdk.enable       = true;
          "clj-kondo".enable = true;
        };

        files.programs = {
          fd.enable      = true;
          ripgrep.enable = true;
        };

        monitoring.programs = {
          btop.enable = true;
        };

        shell-cli.programs = {
          zsh.enable = true;
        };

        shell-tools.programs = {
          atuin.enable    = true;
          fzf.enable      = true;
          starship.enable = true;
          zoxide.enable   = true;
          tldr.enable     = true;
        };

        terminal.programs = {
          tmux.enable = true;
        };
      };
    };
  };

}

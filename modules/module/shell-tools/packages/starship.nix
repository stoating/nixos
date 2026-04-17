{ self, ... }: {
  flake.homeModules.starship = { lib, config, ... }:
  let
    c = self.lib.theme.colors;
  in {
    programs.starship = lib.mkIf config.shell-tools.programs.starship.enable {
      enable = true;
      enableZshIntegration = true;

      settings = {
        add_newline = false;

        format = "$username$hostname$directory$git_branch$git_status$package$nodejs$python$rust$golang$docker_context$cmd_duration$line_break$jobs$time$character";

        character = {
          success_symbol = "[❯](bold ${c.c14})";
          error_symbol = "[❯](bold ${c.c11})";
        };

        directory.style = "bold ${c.c9}";
        git_branch.style = "bold ${c.c15}";
        git_status.style = "bold ${c.c13}";

        username.show_always = false;
        hostname.ssh_only = true;

        time = {
          disabled = false;
          format = "[$time]($style) ";
          style = "bold ${c.c8}";
        };
      };
    };
  };
}
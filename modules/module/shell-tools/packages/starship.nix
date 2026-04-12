{ ... }: {
  flake.homeModules.starship = { ... }: {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;

      settings = {
        add_newline = false;

        format = ''
          $username\
          $hostname\
          $directory\
          $git_branch\
          $git_status\
          $package\
          $nodejs\
          $python\
          $rust\
          $golang\
          $docker_context\
          $cmd_duration\
          $line_break\
          $jobs\
          $time\
          $character
        '';

        character = {
          success_symbol = "[❯](bold green)";
          error_symbol = "[❯](bold red)";
        };

        directory.style = "bold blue";
        git_branch.style = "bold purple";
        git_status.style = "bold yellow";

        username.show_always = false;
        hostname.ssh_only = true;

        time = {
          disabled = false;
          format = "[$time]($style) ";
          style = "bold yellow";
        };
      };
    };
  };
}
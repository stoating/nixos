{ ... }: {
  flake.homeModules.ghostty = { pkgs, lib, config, ... }: {
    config = lib.mkIf config.terminal.programs.ghostty.enable {
      programs.ghostty = {
        enable = true;
        enableZshIntegration = true;
      };

      xdg.configFile."ghostty/config".text = ''
        command = ${pkgs.zsh}/bin/zsh
      '';
    };
  };
}
{ self, ... }: {
  flake.homeModules.ghostty = { pkgs, lib, config, ... }:
  let
    theme   = self.lib.theme;
    opacity = theme.opacity.terminal;
  in {
    config = lib.mkIf config.terminal.programs.ghostty.enable {
      programs.ghostty = {
        enable = true;
        enableZshIntegration = true;
      };

      xdg.configFile."ghostty/config".text = ''
        command = ${pkgs.zsh}/bin/zsh
        theme = ${theme.ghostty}
        background-opacity = ${opacity}
        background-blur-radius = 20
      '';
    };
  };
}
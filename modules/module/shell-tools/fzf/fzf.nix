{ ... }: {
  flake.homeModules.fzf = { lib, config, ... }: {
    programs.fzf = lib.mkIf config.shell-tools.programs.fzf.enable {
      enable = true;
      enableZshIntegration = true;
    };
  };
}

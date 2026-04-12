{ ... }: {
  flake.homeModules.zoxide = { lib, config, ... }: {
    programs.zoxide = lib.mkIf config.shell-tools.programs.zoxide.enable {
      enable = true;
      enableZshIntegration = true;
    };
  };
}

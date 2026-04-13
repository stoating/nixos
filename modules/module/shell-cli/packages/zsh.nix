{ ... }: {
  flake.homeModules.zsh = { config, lib, ... }: {
    programs.zsh = lib.mkIf config.shell-cli.programs.zsh.enable {
      enable = true;
    };
  };
}

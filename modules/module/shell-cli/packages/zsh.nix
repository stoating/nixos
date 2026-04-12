{ ... }: {
  flake.nixosModules.zsh = { config, lib, ... }: {
    config = lib.mkIf (config.shell-cli.type == "zsh") {
      programs.zsh.enable = true;
    };
  };
}

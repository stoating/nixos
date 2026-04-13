{ ... }: {
  flake.homeModules.lazygit = { lib, config, ... }: {
    programs.lazygit = lib.mkIf config.development.programs.lazygit.enable {
      enable = true;
    };
  };
}

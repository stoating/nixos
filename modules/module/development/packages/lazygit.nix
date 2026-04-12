{ ... }: {
  flake.homeModules.lazygit = { lib, config, ... }: {
    programs.lazygit.enable = lib.mkIf config.development.programs.lazygit.enable true;
  };
}

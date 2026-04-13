{ ... }: {
  flake.homeModules.ripgrep = { lib, config, ... }: {
    programs.ripgrep = lib.mkIf config.files.programs.ripgrep.enable {
      enable = true;
    };
  };
}

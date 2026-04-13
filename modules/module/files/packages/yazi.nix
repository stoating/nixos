{ ... }: {
  flake.homeModules.yazi = { lib, config, ... }: {
    programs.yazi = lib.mkIf config.files.programs.yazi.enable {
      enable = true;
      shellWrapperName = "y";
    };
  };
}

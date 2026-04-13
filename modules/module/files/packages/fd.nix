{ ... }: {
  flake.homeModules.fd = { lib, config, ... }: {
    programs.fd = lib.mkIf config.files.programs.fd.enable {
      enable = true;
    };
  };
}

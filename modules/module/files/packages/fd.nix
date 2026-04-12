{ ... }: {
  flake.homeModules.fd = { lib, config, ... }: {
    programs.fd.enable = lib.mkIf config.files.programs.fd.enable true;
  };
}

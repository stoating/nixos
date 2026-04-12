{ ... }: {
  flake.homeModules.jq = { lib, config, ... }: {
    programs.jq.enable = lib.mkIf config.data.programs.jq.enable true;
  };
}

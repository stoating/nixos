{ ... }: {
  flake.homeModules.jq = { lib, config, ... }: {
    programs.jq = lib.mkIf config.data.programs.jq.enable {
      enable = true;
    };
  };
}

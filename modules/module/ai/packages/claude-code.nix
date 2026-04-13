{ ... }: {
  flake.homeModules.claude-code = { lib, config, ... }: {
    programs.claude-code = lib.mkIf config.ai.programs.claude-code.enable {
      enable = true;
    };
  };
}

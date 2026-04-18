{ inputs, ... }: {
  flake.homeModules.claude-code = { lib, config, ... }: {
    programs.claude-code = lib.mkIf config.ai.programs.claude-code.enable {
      enable = true;
    };

    home.file.".claude/commands/nixos-managing" = lib.mkIf config.ai.programs.claude-code.enable {
      source = "${inputs.nixos-management-skill}/nixos-managing";
    };
  };
}

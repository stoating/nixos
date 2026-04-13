{ self, ... }: {
  flake.homeModules.ai = { lib, ... }: {
    imports = [
      self.homeModules.claude-code
    ];

    options.ai.programs = {
      claude-code.enable = lib.mkEnableOption "Claude Code";
    };
  };
}
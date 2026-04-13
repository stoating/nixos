{ self, ... }: {
  flake.homeModules.ai = { lib, ... }: {
    imports = [
      self.homeModules.claude-code
      self.homeModules.claude-desktop
    ];

    options.ai.programs = {
      claude-code.enable    = lib.mkEnableOption "Claude Code";
      claude-desktop.enable = lib.mkEnableOption "Claude Desktop";
    };
  };
}
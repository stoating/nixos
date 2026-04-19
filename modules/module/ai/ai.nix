{ self, inputs, ... }: {
  flake.homeModules.ai = { lib, config, ... }: {
    imports = [
      self.homeModules.claude-code
      self.homeModules.claude-desktop
      self.homeModules.codex
      self.homeModules.whisper-cpp
    ];

    options.ai.programs = {
      claude-code.enable    = lib.mkEnableOption "Claude Code";
      claude-desktop.enable = lib.mkEnableOption "Claude Desktop";
      codex.enable          = lib.mkEnableOption "Codex";
      whisper-cpp.enable    = lib.mkEnableOption "whisper-cpp";
    };

    config.home.file."nixos/.claude/skills/nixos-managing" =
      lib.mkIf (config.ai.programs.claude-code.enable || config.ai.programs.codex.enable) {
        source = "${inputs.nixos-management-skill}/nixos-managing";
      };
  };
}
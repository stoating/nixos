{ ... }: {
  flake.homeModules.codex = { lib, config, pkgs, ... }: {
    home.packages = lib.mkIf config.ai.programs.codex.enable [
      pkgs.codex
    ];
  };
}

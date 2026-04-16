{ ... }: {
  flake.homeModules.whisper-cpp = { pkgs, lib, config, ... }: {
    home.packages = lib.mkIf config.ai.programs.whisper-cpp.enable [
      pkgs.whisper-cpp
    ];
  };
}

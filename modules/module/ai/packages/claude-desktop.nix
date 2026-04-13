{ inputs, ... }: {
  flake.homeModules.claude-desktop = { pkgs, lib, config, ... }: {
    home.packages = lib.mkIf config.ai.programs.claude-desktop.enable [
      inputs.claude-desktop.packages.${pkgs.stdenv.hostPlatform.system}.claude-desktop-with-fhs
    ];

    xdg.desktopEntries.claude = lib.mkIf config.ai.programs.claude-desktop.enable {
      name = "Claude";
      genericName = "Claude Desktop";
      exec = "claude-desktop --ozone-platform=wayland --enable-features=UseOzonePlatform --disable-gpu %u";
      icon = "claude";
      categories = [ "Office" "Utility" ];
      mimeType = [ "x-scheme-handler/claude" ];
      terminal = false;
    };
  };
}

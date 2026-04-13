{ ... }: {
  flake.homeModules.chromium = { lib, config, ... }: {
    programs.chromium = lib.mkIf config.browser.programs.chromium.enable {
      enable = true;
      commandLineArgs = [
        "--enable-features=WaylandWindowDecorations"
        "--ozone-platform-hint=auto"
      ];
    };
  };
}

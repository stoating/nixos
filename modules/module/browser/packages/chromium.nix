{ ... }: {
  flake.homeModules.chromium = { pkgs, lib, config, ... }: {
    programs.chromium = lib.mkIf config.browser.programs.chromium.enable {
      enable = true;
      package = pkgs.chromium;
      commandLineArgs = [
        "--enable-features=WaylandWindowDecorations"
        "--ozone-platform-hint=auto"
      ];
    };
  };
}

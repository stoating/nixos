{ ... }: {
  flake.homeModules.chromium = { pkgs, ... }: {
    programs.chromium = {
      package = pkgs.chromium;
      commandLineArgs = [
        "--enable-features=WaylandWindowDecorations"
        "--ozone-platform-hint=auto"
      ];
    };
  };
}

{ ... }: {
  flake.homeModules.chrome = { pkgs, ... }: {
    programs.chromium = {
      enable = true;
      package = pkgs.google-chrome;
    };
  };
}

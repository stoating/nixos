{ ... }: {
  flake.homeModules.chrome = { pkgs, ... }: {
    programs.google-chrome.enable = true;
  };
}

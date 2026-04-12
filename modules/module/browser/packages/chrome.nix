{ ... }: {
  flake.homeModules.chrome = { ... }: {
    programs.google-chrome.enable = true;
  };
}

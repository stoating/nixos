{ ... }: {
  flake.homeModules.chrome = { lib, config, ... }: {
    programs.google-chrome.enable = lib.mkIf config.browser.programs.chrome.enable true;
  };
}

{ ... }: {
  flake.homeModules.chrome = { lib, config, ... }: {
    programs.google-chrome = lib.mkIf config.browser.programs.chrome.enable {
      enable = true;
    };
  };
}

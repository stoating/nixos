{ ... }: {
  flake.homeModules.firefox = { lib, config, ... }: {
    programs.firefox = lib.mkIf config.browser.programs.firefox.enable {
      enable = true;
    };
  };
}

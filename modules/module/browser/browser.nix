{ self, ... }: {
  flake.homeModules.browser = { config, lib, ... }: {
    imports = [
      self.homeModules.chrome
      self.homeModules.chromium
      self.homeModules.firefox
    ];

    options.browser.programs = {
      chrome.enable   = lib.mkEnableOption "Google Chrome (proprietary)";
      chromium.enable = lib.mkEnableOption "Google Chrome";
      firefox.enable  = lib.mkEnableOption "Firefox";
    };

    config = lib.mkMerge [
      (lib.mkIf config.browser.programs.chromium.enable {
        programs.chromium.enable = true;
      })
      (lib.mkIf config.browser.programs.firefox.enable {
        programs.firefox.enable = true;
      })
      (lib.mkIf config.browser.programs.chrome.enable {
        programs.google-chrome.enable = true;
      })
    ];
  };
}

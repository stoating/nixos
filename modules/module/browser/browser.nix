{ self, ... }: {
  flake.homeModules.browser = { lib, ... }: {
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
  };
}

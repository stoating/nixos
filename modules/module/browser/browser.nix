{ self, lib, ... }: {
  flake.module.browser = { config, lib, ... }: {
    imports = [
      self.program.chromium
      self.program.firefox
    ];

    options.browser.programs = {
      chromium.enable = lib.mkEnableOption "Google Chrome";
      firefox.enable = lib.mkEnableOption "Firefox";
    };

    config = lib.mkMerge [
      (lib.mkIf config.browser.programs.chromium.enable {
        programs.chromium.enable = true;
      })
      (lib.mkIf config.browser.programs.firefox.enable {
        programs.firefox.enable = true;
      })
    ];
  };
}

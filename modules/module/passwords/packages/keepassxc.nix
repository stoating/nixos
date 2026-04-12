{ ... }: {
  flake.homeModules.keepassxc = { lib, config, ... }: {
    programs.keepassxc = lib.mkIf config.passwords.programs.keepassxc.enable {
      enable = true;
      settings = {
        Browser.Enabled = true;
        Browser.UpdateBinaryPath = false; # prevent conflict with home-manager's manifest
        GUI = {
          ApplicationTheme = "dark";
          HidePasswords = true;
        };
      };
    };
  };
}

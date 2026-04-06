{ ... }: {
  flake.program.keepassxc = { ... }: {
    programs.keepassxc = {
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

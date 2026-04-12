{ self, ... }: {
  flake.homeModules.passwords = { lib, ... }: {
    imports = [
      self.homeModules.keepassxc
    ];

    options.passwords.programs = {
      keepassxc.enable = lib.mkEnableOption "KeePassXC";
    };
  };
}

{ self, lib, ... }: {
  flake.homeModules.passwords = { config, lib, ... }: {
    imports = [
      self.homeModules.keepassxc
    ];

    options.passwords.programs = {
      keepassxc.enable = lib.mkEnableOption "KeePassXC";
    };

    config = lib.mkMerge [
      (lib.mkIf config.passwords.programs.keepassxc.enable {
        programs.keepassxc.enable = true;
      })
    ];
  };
}

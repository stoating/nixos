{ self, ... }: {
  flake.homeModules.backup = { lib, ... }: {
    imports = [
      self.homeModules.restic
    ];

    options.backup.programs = {
      restic.enable = lib.mkEnableOption "restic";
    };
  };
}

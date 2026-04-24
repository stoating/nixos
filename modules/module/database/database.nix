{ self, ... }: {
  flake.homeModules.database = { lib, ... }: {
    imports = [
      self.homeModules.nix-index
    ];

    options.database.programs = {
      nix-index.enable = lib.mkEnableOption "nix-index";
    };
  };
}

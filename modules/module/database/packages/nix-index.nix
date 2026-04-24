{ inputs, ... }: {
  flake.homeModules.nix-index = { lib, config, ... }: {
    imports = [
      inputs.nix-index-database.homeModules.nix-index
    ];

    config = lib.mkIf config.database.programs.nix-index.enable {
      programs.nix-index.enable = true;
      programs.nix-index-database.comma.enable = true;
    };
  };
}

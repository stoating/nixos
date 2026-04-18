{ ... }: {
  flake.homeModules."clj-kondo" = { pkgs, lib, config, ... }: {
    home.packages = lib.mkIf config.development.languages."clj-kondo".enable [
      pkgs.clj-kondo
    ];
  };
}

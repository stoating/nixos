{ ... }: {
  flake.homeModules."clj-kondo" = { pkgs, lib, config, ... }: {
    home.packages = lib.mkIf config.development."language-tools"."clj-kondo".enable [
      pkgs.clj-kondo
    ];
  };
}

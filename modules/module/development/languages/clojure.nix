{ ... }: {
  flake.homeModules.clojure = { pkgs, lib, config, ... }: {
    home.packages = lib.mkIf config.development.languages.clojure.enable [
      pkgs.clojure
    ];
  };
}

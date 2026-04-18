{ ... }: {
  flake.homeModules.jdk = { pkgs, lib, config, ... }: {
    home.packages = lib.mkIf config.development.languages.jdk.enable [
      pkgs.jdk
    ];
  };
}

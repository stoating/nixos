{ ... }: {
  flake.homeModules.kdenlive = { pkgs, lib, config, ... }: {
    home.packages = lib.mkIf config.media.programs.kdenlive.enable [
      pkgs.kdePackages.kdenlive
    ];
  };
}

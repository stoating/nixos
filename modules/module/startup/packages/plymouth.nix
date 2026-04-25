{ ... }: {
  flake.nixosModules.plymouth = { lib, config, ... }: {
    config = lib.mkIf config.startup.plymouth.enable {
      boot.plymouth = {
        enable = true;
        inherit (config.startup.plymouth) theme themePackages;
      };
    };
  };
}

{ ... }: {
  flake.homeModules.yq = { pkgs, lib, config, ... }: {
    home.packages = lib.mkIf config.data.programs.yq.enable [ pkgs.yq-go ];
  };
}

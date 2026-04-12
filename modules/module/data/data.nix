{ self, ... }: {
  flake.homeModules.data = { lib, ... }: {
    imports = [
      self.homeModules.jq
      self.homeModules.yq
    ];

    options.data.programs = {
      jq.enable = lib.mkEnableOption "jq";
      yq.enable = lib.mkEnableOption "yq";
    };
  };
}

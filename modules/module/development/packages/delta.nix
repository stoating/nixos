{ self, ... }: {
  flake.homeModules.delta = { lib, config, ... }: {
    programs.delta = lib.mkIf config.development.programs.delta.enable {
      enable = true;
      enableGitIntegration = true;
      options = {
        navigate = true;
        side-by-side = true;
        syntax-theme = self.lib.theme.delta;
      };
    };
  };
}

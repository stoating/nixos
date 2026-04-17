{ ... }: {
  flake.homeModules.delta = { lib, config, ... }: {
    programs.git.delta = lib.mkIf config.development.programs.delta.enable {
      enable = true;
      options = {
        navigate = true;
        side-by-side = true;
        syntax-theme = "Nord";
      };
    };
  };
}

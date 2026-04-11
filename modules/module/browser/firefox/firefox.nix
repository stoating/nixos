{ ... }: {
  flake.homeModules.firefox = { pkgs, ... }: {
    programs.firefox = {
      package = pkgs.firefox;
    };
  };
}

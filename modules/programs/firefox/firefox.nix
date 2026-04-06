{ ... }: {
  flake.program.firefox = { pkgs, ... }: {
    programs.firefox = {
      package = pkgs.firefox;
    };
  };
}

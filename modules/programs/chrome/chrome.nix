{ ... }: {
  flake.program.chrome = { pkgs, lib, ... }: {
    programs.chromium = {
      package = pkgs.google-chrome;
    };
  };
}

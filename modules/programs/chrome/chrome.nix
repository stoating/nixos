{ ... }: {
  flake.program.chrome = { pkgs, ... }: {
    programs.google-chrome.enable = true;
  };
}

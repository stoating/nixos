{ inputs, ... }: {
  flake.program.noctalia = { ... }: {
    home-manager.users.zack = {
      imports = [ inputs.noctalia.homeModules.default ];
      programs.noctalia-shell.enable = true;
    };
  };
}

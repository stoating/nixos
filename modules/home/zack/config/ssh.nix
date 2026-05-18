{ ... }: {
  flake.homeModules.zacks-ssh = { ... }: {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      settings = {
        "*" = {
          AddKeysToAgent = "yes";
          ServerAliveInterval = 60;
        };
        "github.com" = {
          User = "git";
          IdentityFile = "~/.ssh/id_ed25519";
        };
      };
    };
  };
}

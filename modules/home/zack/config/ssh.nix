{ ... }: {
  flake.homeModules.zacks-ssh = { ... }: {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      matchBlocks = {
        "*" = {
          addKeysToAgent = "yes";
          serverAliveInterval = 60;
        };
        "github.com" = {
          user = "git";
          identityFile = "~/.ssh/id_ed25519";
        };
      };
    };
  };
}

{ self, ... }: {
  flake.nixosModules.shell-cli = { pkgs, config, lib, ... }: {
    imports = [
      self.nixosModules.zsh
      self.nixosModules.fish
      self.nixosModules.nushell
    ];

    options.shell-cli.type = lib.mkOption {
      type = lib.types.enum [ "zsh" "fish" "nushell" ];
      default = "zsh";
      description = "CLI shell to use as login shell.";
    };

    config = lib.mkMerge [
      (lib.mkIf (config.shell-cli.type == "zsh")     { users.users.zack.shell = pkgs.zsh; })
      (lib.mkIf (config.shell-cli.type == "fish")    { users.users.zack.shell = pkgs.fish; })
      (lib.mkIf (config.shell-cli.type == "nushell") { users.users.zack.shell = pkgs.nushell; })
    ];
  };
}

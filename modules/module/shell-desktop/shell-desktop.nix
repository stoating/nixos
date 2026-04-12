{ self, lib, config, ... }: {
  config = {
    flake.nixosModules.shell-desktop = { lib, ... }: {
      imports = [ self.nixosModules.noctalia ];

      options.shell-desktop.type = lib.mkOption {
        type = lib.types.enum [ "noctalia" ];
        default = "noctalia";
        description = "Desktop shell to use.";
      };
    };

    flake.shell-desktop.program =
      lib.mkIf (config.flake.shell-desktop.type == "noctalia") "noctalia-shell";
    flake.shell-desktop.launcher-command =
      lib.mkIf (config.flake.shell-desktop.type == "noctalia") "noctalia-shell ipc call launcher toggle";
  };

  options.flake.shell-desktop = {
    type = lib.mkOption {
      type = lib.types.str;
      default = "noctalia";
    };
    program = lib.mkOption {
      type = lib.types.str;
      description = "Shell program binary name.";
    };
    launcher-command = lib.mkOption {
      type = lib.types.str;
      description = "Command to toggle the shell's app launcher.";
    };
  };
}

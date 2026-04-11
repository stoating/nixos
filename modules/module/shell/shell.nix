{ self, lib, config, ... }: {
  config = {
    flake.nixosModules.shell = { lib, ... }: {
      imports = [ self.nixosModules.noctalia ];

      options.shell.type = lib.mkOption {
        type = lib.types.enum [ "noctalia" ];
        default = "noctalia";
        description = "Desktop shell to use.";
      };
    };

    flake.shell.program =
      lib.mkIf (config.flake.shell.type == "noctalia") "noctalia-shell";
    flake.shell.launcher-command =
      lib.mkIf (config.flake.shell.type == "noctalia") "noctalia-shell ipc call launcher toggle";
  };

  options.flake.shell = {
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

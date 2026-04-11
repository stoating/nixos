{ self, lib, ... }: {
  flake.module.shell = { config, lib, ... }: {
    imports = [ self.program.noctalia ];

    options.shell.type = lib.mkOption {
      type = lib.types.enum [ "noctalia" ];
      default = "noctalia";
      description = "Desktop shell to use.";
    };
  };
}

{ self, lib, ... }: {
  flake.nixosModules.shell = { config, lib, ... }: {
    imports = [ self.nixosModules.noctalia ];

    options.shell.type = lib.mkOption {
      type = lib.types.enum [ "noctalia" ];
      default = "noctalia";
      description = "Desktop shell to use.";
    };
  };
}

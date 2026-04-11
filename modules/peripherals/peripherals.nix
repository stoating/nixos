{ self, ... }: {
  flake.nixosModules.peripherals = { ... }: {
    imports = [
      self.nixosModules.monitors
    ];
  };
}

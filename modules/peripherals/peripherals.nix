{ self, ... }: {
  flake.nixosModules.peripherals = { ... }: {
    imports = [
      self.nixosModules.monitors
      self.nixosModules.keyboard
      self.nixosModules.wally-cli
      self.nixosModules.printer
    ];
  };
}

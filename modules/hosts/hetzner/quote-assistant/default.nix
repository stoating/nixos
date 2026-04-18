{ self, inputs, ... }: {

  flake.nixosConfigurations.quote-assistant = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.nixosModules.quote-assistant-configuration
    ];
  };

}

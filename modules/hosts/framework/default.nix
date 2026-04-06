{ self, inputs, ... }: {

  flake.nixosConfigurations.framework = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.framework-configuration
    ];
  };

}

{ self, ... }: {
  flake.nixosModules.zacks-monitors = { ... }: {
    monitors = [
      {
        name     = self.lib.monitors.hp;
        position = { x = 0; y = 0; };
      }
      {
        name     = self.lib.monitors.fw;
        scale    = 1.5;
        position = { x = 1920; y = 0; };
      }
    ];
  };
}

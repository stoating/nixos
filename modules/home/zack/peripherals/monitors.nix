{ ... }: {
  flake.nixosModules.zacks-monitors = { ... }: {
    monitors = [
      {
        name     = "DP-1";
        position = { x = 0; y = 0; };
      }
      {
        name     = "eDP-2";
        scale    = 1.5;
        position = { x = 1920; y = 0; };
      }
    ];
  };
}

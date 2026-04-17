{ ... }: {
  flake.nixosModules.zacks-nas = { ... }: {
    nas = {
      enable        = true;
      user          = "zack";
      uid           = 1000;
      gid           = 100;
      host          = "192.168.178.145";
      share         = "homes";
      synologyDrive = true;
    };
  };
}

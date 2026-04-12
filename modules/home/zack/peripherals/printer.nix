{ ... }: {
  flake.nixosModules.zacks-printer = { ... }: {
    printers = {
      default = "Brother-MFC-J4340DW";
      devices = [
        {
          name      = "Brother-MFC-J4340DW";
          location  = "Office";
          deviceUri = "ipp://192.168.178.50/ipp/print";
          pageSize  = "A4";
        }
      ];
    };
  };
}

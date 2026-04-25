{ self, ... }: {
  flake.nixosModules.framework-startup = { ... }: {
    imports = [
      self.nixosModules.startup
      self.nixosModules.framework-elegant-grub2
      self.nixosModules.framework-plymouth
      self.nixosModules.framework-nwg-hello
    ];

    startup = {
      grub.theme = "elegant-grub2";
      plymouth.enable = true;
      nwg-hello.enable = true;
    };
  };
}

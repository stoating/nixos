{ ... }: {
  flake.nixosModules.zacks-elegant-grub2 = { ... }: {
    startup.grub.gfxmodeEfi = "2560x1600,2560x1440,auto";
  };
}

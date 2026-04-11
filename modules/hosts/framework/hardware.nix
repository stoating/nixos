{ ... }: {

  flake.nixosModules.framework-hardware = { config, lib, modulesPath, ... }: {
    imports =
      [ (modulesPath + "/installer/scan/not-detected.nix")
      ];

    boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usbhid" "usb_storage" "sd_mod" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-amd" ];
    boot.extraModulePackages = [ ];

    fileSystems."/" =
      { device = "/dev/mapper/luks-fc9114b1-0781-498c-90ba-02ca49773a28";
        fsType = "ext4";
      };

    boot.initrd.luks.devices."luks-fc9114b1-0781-498c-90ba-02ca49773a28".device = "/dev/disk/by-uuid/fc9114b1-0781-498c-90ba-02ca49773a28";

    fileSystems."/boot" =
      { device = "/dev/disk/by-uuid/1696-A974";
        fsType = "vfat";
        options = [ "fmask=0077" "dmask=0077" ];
      };

    swapDevices =
      [ { device = "/dev/mapper/luks-e13d7e39-2fc5-4ce4-8f3c-420e2197a26b"; }
      ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}

{ self, ... }: {

  flake.nixosModules.framework-configuration = { pkgs, config, ... }: {
    imports = [
      self.nixosModules.framework-hardware
      self.nixosModules.home-zack
    ];

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Use latest kernel.
    boot.kernelPackages = pkgs.linuxPackages_latest;

    boot.initrd.luks.devices."luks-e13d7e39-2fc5-4ce4-8f3c-420e2197a26b".device = "/dev/disk/by-uuid/e13d7e39-2fc5-4ce4-8f3c-420e2197a26b";
    networking.hostName = "nixos"; # Define your hostname.

    nix = {
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
      };
    };

    # Enable networking
    networking.networkmanager.enable = true;

    # Set your time zone.
    time.timeZone = "Europe/Berlin";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };

    hardware = {
      bluetooth = {
        enable = true;
      };
    };

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the GNOME Desktop Environment.
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    # Configure keymap in X11
    services.xserver.xkb = {
      layout  = config.keyboard.xkb.layout;
      variant = config.keyboard.xkb.variant;
    };

    # Configure console keymap
    console.keyMap = config.keyboard.xkb.layout;

    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    users.users.zack = {
      isNormalUser = true;
      description = "zack";
      extraGroups = [ "networkmanager" "wheel" ];
    };

    nixpkgs.config.allowUnfree = true;

    environment = {
      systemPackages = with pkgs; [
        synology-drive-client
        ];
    };

    system.stateVersion = "25.11";
  };
}

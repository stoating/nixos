{ self, ... }: {

  flake.nixosModules.framework-configuration = { pkgs, lib, config, ... }: {
    imports = [
      self.nixosModules.framework-hardware
      self.nixosModules.home-zack
    ];

    boot = {
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;
      kernelPackages = pkgs.linuxPackages_latest;
      initrd.luks.devices."luks-e13d7e39-2fc5-4ce4-8f3c-420e2197a26b".device =
        "/dev/disk/by-uuid/e13d7e39-2fc5-4ce4-8f3c-420e2197a26b";
    };

    networking = {
      firewall.enable = true;
      hostName = "fw";
      networkmanager.enable = true;
    };

    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [ "root" "zack" ];
      substituters = [
        "https://cache.nixos.org"
        "https://devenv.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      ];
    };

    time.timeZone = "Europe/Berlin";

    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
        LC_ADDRESS        = "de_DE.UTF-8";
        LC_IDENTIFICATION = "de_DE.UTF-8";
        LC_MEASUREMENT    = "de_DE.UTF-8";
        LC_MONETARY       = "de_DE.UTF-8";
        LC_NAME           = "de_DE.UTF-8";
        LC_NUMERIC        = "de_DE.UTF-8";
        LC_PAPER          = "de_DE.UTF-8";
        LC_TELEPHONE      = "de_DE.UTF-8";
        LC_TIME           = "de_DE.UTF-8";
      };
    };

    hardware.bluetooth = {
      enable       = true;
      powerOnBoot  = false;
    };

    # Keep xdg-desktop-portal from activating the GTK backend under niri.
    # It times out during startup and blocks first app launches, including Ghostty.
    xdg.portal.config.niri = {
      default = lib.mkForce [ "gnome" ];
      "org.freedesktop.impl.portal.Access" = lib.mkForce [ "gnome" ];
      "org.freedesktop.impl.portal.Notification" = lib.mkForce [ "gnome" ];
      "org.freedesktop.impl.portal.Inhibit" = lib.mkForce [ "none" ];
      "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
    };

    services = {
      xserver = {
        enable = true;
        xkb = {
          layout  = config.keyboard.xkb.layout;
          variant = config.keyboard.xkb.variant;
        };
      };
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      pulseaudio.enable = false;
      pipewire = {
        enable            = true;
        alsa.enable       = true;
        alsa.support32Bit = true;
        pulse.enable      = true;
      };
    };

    console.keyMap = config.keyboard.xkb.layout;

    security = {
      rtkit.enable = true;
      sudo.wheelNeedsPassword = true;
    };

    virtualisation = {
      docker.enable = true;
      podman.enable = true;
    };

    nix.gc = {
      automatic = true;
      dates     = "weekly";
      options   = "--delete-older-than 30d";
    };

    users.users.zack = {
      isNormalUser = true;
      description  = "zack";
      extraGroups  = [ "networkmanager" "wheel" "video" "docker" ];
    };

    nixpkgs.config.allowUnfree = true;

    system.stateVersion = "25.11";
  };
}

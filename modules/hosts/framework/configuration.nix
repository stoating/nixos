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

    # Force niri to use only the GNOME portal backend.
    # The default niri-portals.conf includes gtk as a fallback, but
    # xdg-desktop-portal-gtk times out on startup (25s per interface),
    # causing Ghostty and the file manager to hang for ~15s on first launch.
    # The GNOME portal handles every interface the GTK portal does.
    xdg.portal.config.niri = {
      default = lib.mkForce [ "gnome" ];
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

    users.users.zack = {
      isNormalUser = true;
      description  = "zack";
      extraGroups  = [ "networkmanager" "wheel" "video" ];
    };

    nixpkgs.config.allowUnfree = true;

    system.stateVersion = "25.11";
  };
}

{ self, inputs, ... }: {

  flake.nixosModules.framework-configuration = { pkgs, lib, ... }: {
    imports = [
      self.nixosModules.framework-hardware
      self.nixosModules.niri
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
      layout = "de";
      variant = "";
    };

    # Configure console keymap
    console.keyMap = "de";

    # Enable CUPS to print documents.
    services.printing = {
      enable = true;
      browsing = true;
      drivers = with pkgs; [
        cups-filters   # IPP Everywhere / driverless support
      ];
    };

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
      shell = pkgs.zsh;
      packages = with pkgs; [
      ];
    };

    nixpkgs.config.allowUnfree = true;

    environment = {
      sessionVariables = {
        NIXOS_OZONE_WL = "1"; # for vscode
      };
      systemPackages = with pkgs; [
        asciinema_3
        atuin
        atuin-desktop
        bandwhich
        bat
        btop
        cifs-utils # for nas mount
        direnv
        discord
        docker
        fd
        fzf
        ghostty
        git
        gh
        gping
        google-cursor
        jq
        keepassxc
        lazygit
        libreoffice
        mc
        navi
        obs-studio
        onlyoffice-desktopeditors
        pear-desktop
        podman
        podman-desktop
        ripgrep
        synology-drive-client
        tldr
        tmux
        vim
        wally-cli
        wpsoffice
        yazi
        yq-go
        zoxide
        zsh
        ];
    };

    programs.firefox.enable = true;
    programs.zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        cat = "bat --paging=never";
      };
      interactiveShellInit = ''
        export BAT_THEME="Nord"
        export MANPAGER="sh -c 'col -bx | bat -l man -p'"
        export MANROFFOPT="-c"
      '';
    };

    # Create mount point directories (for NAS)
    systemd.tmpfiles.rules = [
      "d /mnt/nas 0755 zack users -"
      "d /home/zack/nas 0755 zack users -"
    ];

    # Mount Synology NAS share via SMB
    # Credentials file must be created manually at /etc/smb-credentials:
    #   username=Zachary
    #   password=YOUR_PASSWORD
    # Then: sudo chmod 600 /etc/smb-credentials
    fileSystems."/mnt/nas" = {
      device = "//192.168.178.145/homes";
      fsType = "cifs";
      options = [
        "credentials=/etc/smb-credentials"
        "uid=1000"
        "gid=100"
        "x-systemd.automount"
        "noauto"
        "x-systemd.idle-timeout=60"
        "x-systemd.device-timeout=5s"
        "x-systemd.mount-timeout=5s"
      ];
    };

    # Bind mount so the share is also accessible at ~/nas
    # noauto + x-systemd.automount ensures it only mounts on access, after the CIFS mount is ready
    fileSystems."/home/zack/nas" = {
      device = "/mnt/nas";
      fsType = "none";
      options = [ "bind" "noauto" "x-systemd.automount" "x-systemd.requires-mounts-for=/mnt/nas" ];
    };

    # Required for Synology Drive tray / mDNS discovery
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    # GNOME Keyring for credential storage (used by Synology Drive)
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.gdm.enableGnomeKeyring = true;

    system.stateVersion = "25.11";
  };
}

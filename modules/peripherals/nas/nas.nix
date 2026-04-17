{ ... }: {
  flake.nixosModules.nas = { pkgs, lib, config, ... }: {
    options.nas = {
      enable = lib.mkEnableOption "NAS SMB mount";
      user = lib.mkOption {
        type        = lib.types.str;
        description = "Local user that owns the mount.";
      };
      uid = lib.mkOption {
        type        = lib.types.int;
        description = "UID of the local user.";
      };
      gid = lib.mkOption {
        type        = lib.types.int;
        default     = 100;
        description = "GID of the local users group.";
      };
      host = lib.mkOption {
        type        = lib.types.str;
        description = "NAS hostname or IP address.";
      };
      share = lib.mkOption {
        type        = lib.types.str;
        description = "SMB share name on the NAS.";
      };
      credentialsFile = lib.mkOption {
        type        = lib.types.str;
        default     = "/etc/smb-credentials";
        description = "Path to the SMB credentials file.";
      };
      mountPoint = lib.mkOption {
        type        = lib.types.str;
        default     = "/mnt/nas";
        description = "Primary mount point for the SMB share.";
      };
      synologyDrive = lib.mkOption {
        type        = lib.types.bool;
        default     = false;
        description = "Install Synology Drive client for tray and sync support.";
      };
    };

    config = lib.mkIf config.nas.enable {
      environment.systemPackages = [ pkgs.cifs-utils ]
        ++ lib.optional config.nas.synologyDrive pkgs.synology-drive-client;

      systemd.tmpfiles.rules = [
        "d ${config.nas.mountPoint} 0755 ${config.nas.user} users -"
      ];

      fileSystems."${config.nas.mountPoint}" = {
        device = "//${config.nas.host}/${config.nas.share}";
        fsType = "cifs";
        options = [
          "credentials=${config.nas.credentialsFile}"
          "uid=${toString config.nas.uid}"
          "gid=${toString config.nas.gid}"
          "x-systemd.automount"
          "noauto"
          "nofail"
          "x-systemd.idle-timeout=60"
          "x-systemd.device-timeout=5s"
          "x-systemd.mount-timeout=5s"
        ];
      };

      # mDNS discovery (required for Synology Drive tray)
      services.avahi = {
        enable       = true;
        nssmdns4     = true;
        openFirewall = true;
      };

      # GNOME Keyring for credential storage (used by Synology Drive)
      services.gnome.gnome-keyring.enable = true;
      security.pam.services.gdm.enableGnomeKeyring = true;
    };
  };
}

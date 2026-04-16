{ ... }: {
  flake.homeModules.zacks-restic = { lib, config, ... }: {
    services.restic.backups = lib.mkIf config.backup.programs.restic.enable {
      home = {
        repository   = "/home/zack/SynologyDrive/Personal/My Devices/backup";
        # Create before rebuilding: echo "your-password" > ~/.config/restic/password && chmod 600 ~/.config/restic/password
        passwordFile = "/home/zack/.config/restic/password";
        paths = [
          "/home/zack/desktop"
          "/home/zack/documents"
          "/home/zack/music"
          "/home/zack/pictures"
          "/home/zack/videos"
          "/home/zack/nixos"
          "/home/zack/.config"
          "/home/zack/.local/share"
          "/home/zack/.ssh"
          "/home/zack/.gnupg"
        ];
        exclude = [
          # Caches
          "/home/zack/.config/Code/Cache*"
          "/home/zack/.config/Code/CachedData"
          "/home/zack/.config/Code/CachedExtensionVSIXs"
          # Container images — huge and reproducible
          "/home/zack/.local/share/containers"
          "/home/zack/.local/share/flatpak"
          # Trash
          "/home/zack/.local/share/Trash"
          # Build artifacts — reproducible
          "node_modules"
          "target"
          "__pycache__"
          "*.pyc"
          "*.class"
          ".gradle"
        ];
      };
    };
  };
}

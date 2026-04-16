{ ... }: {
  flake.homeModules.restic = { lib, config, ... }: {
    services.restic = lib.mkIf config.backup.programs.restic.enable {
      enable = true;

      backups = {
        home = {
          initialize  = true;
          timerConfig = {
            OnCalendar = "daily";
            Persistent = true;
          };
          pruneOpts = [
            "--keep-daily 7"
            "--keep-weekly 4"
            "--keep-monthly 12"
          ];
        };
      };
    };
  };
}

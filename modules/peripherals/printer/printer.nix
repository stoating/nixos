{ ... }: {
  flake.nixosModules.printer = { pkgs, lib, config, ... }: {
    options.printers = {
      browsing = lib.mkOption {
        type        = lib.types.bool;
        default     = false;
        description = "Enable CUPS network printer browsing/discovery.";
      };
      default = lib.mkOption {
        type        = lib.types.str;
        default     = "";
        description = "Name of the default printer.";
      };
      devices = lib.mkOption {
        type = lib.types.listOf (lib.types.submodule {
          options = {
            name = lib.mkOption {
              type        = lib.types.str;
              description = "Printer name (no spaces).";
            };
            location = lib.mkOption {
              type        = lib.types.str;
              default     = "";
              description = "Physical location description.";
            };
            deviceUri = lib.mkOption {
              type        = lib.types.str;
              description = "Device URI (e.g. ipp://192.168.1.x/ipp/print).";
            };
            pageSize = lib.mkOption {
              type        = lib.types.str;
              default     = "A4";
              description = "Default page size.";
            };
          };
        });
        default     = [];
        description = "List of printers to configure.";
      };
    };

    config = lib.mkIf (config.printers.devices != []) {
      services.printing = {
        enable   = true;
        browsing = config.printers.browsing;
        drivers  = [ pkgs.cups-filters ];
      };

      hardware.printers = {
        ensurePrinters = map (p: {
          name       = p.name;
          location   = p.location;
          deviceUri  = p.deviceUri;
          model      = "everywhere";
          ppdOptions = { PageSize = p.pageSize; };
        }) config.printers.devices;

        ensureDefaultPrinter = config.printers.default;
      };

      # nixpkgs provisions printers from cups.service's postStart, which runs
      # under `set -e` — an asleep printer would otherwise take the scheduler
      # down. Definitions persist in /var/lib/cups, so a failed re-add is safe.
      systemd.services.cups = {
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];

        postStart = lib.mkForce (
          lib.concatMapStringsSep "\n"
            (p: ''
              lpadmin -p ${lib.escapeShellArg p.name} -E \
                -L ${lib.escapeShellArg p.location} \
                -m everywhere \
                -o PageSize=${lib.escapeShellArg p.pageSize} \
                -v ${lib.escapeShellArg p.deviceUri} \
                || echo "cups: could not provision ${p.name} (offline?) — keeping existing definition"
            '')
            config.printers.devices
          + lib.optionalString (config.printers.default != "") ''

            lpadmin -d ${lib.escapeShellArg config.printers.default} \
              || echo "cups: could not set default printer ${config.printers.default}"
          ''
        );
      };
    };
  };
}

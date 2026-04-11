{ ... }: {
  flake.nixosModules.monitors = { lib, ... }: {
    options.monitors = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          name = lib.mkOption {
            type        = lib.types.str;
            description = "Output connector name as reported by the compositor (e.g. DP-1, eDP-2).";
          };
          scale = lib.mkOption {
            type        = lib.types.float;
            default     = 1.0;
            description = "Output scale factor.";
          };
          position = lib.mkOption {
            type = lib.types.submodule {
              options = {
                x = lib.mkOption { type = lib.types.int; default = 0; };
                y = lib.mkOption { type = lib.types.int; default = 0; };
              };
            };
            default     = { x = 0; y = 0; };
            description = "Output position in the global coordinate space.";
          };
        };
      });
      default     = [];
      description = "Monitor/output definitions shared across compositors.";
    };
  };
}

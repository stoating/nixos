{ ... }: {
  flake.nixosModules.keyboard = { lib, ... }: {
    options.keyboard.xkb = {
      layout = lib.mkOption {
        type        = lib.types.str;
        default     = "us";
        description = "XKB keyboard layout (e.g. de, us, gb).";
      };
      variant = lib.mkOption {
        type        = lib.types.str;
        default     = "";
        description = "XKB keyboard variant.";
      };
    };
  };
}

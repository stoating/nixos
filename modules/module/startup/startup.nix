{ self, ... }: {
  flake.nixosModules.startup = { lib, ... }: {
    imports = [
      self.nixosModules.elegant-grub2
      self.nixosModules.plymouth
    ];

    options.startup.grub = {
      theme = lib.mkOption {
        type        = lib.types.enum [ "elegant-grub2" "none" ];
        default     = "none";
        description = "GRUB boot theme to use.";
      };
      gfxmodeEfi = lib.mkOption {
        type        = lib.types.str;
        default     = "auto";
        description = "GRUB EFI graphics resolution string.";
      };
      timeout = lib.mkOption {
        type        = lib.types.int;
        default     = 3;
        description = "Boot menu timeout in seconds.";
      };
    };

    options.startup.plymouth = {
      enable = lib.mkEnableOption "Plymouth boot splash";
      theme = lib.mkOption {
        type        = lib.types.str;
        default     = "breeze";
        description = "Plymouth theme name.";
      };
      themePackages = lib.mkOption {
        type        = lib.types.listOf lib.types.package;
        default     = [];
        description = "Packages providing the selected Plymouth theme.";
      };
    };
  };
}

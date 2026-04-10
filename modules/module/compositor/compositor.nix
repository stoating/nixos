{ self, lib, ... }: {
  flake.module.compositor = { config, lib, ... }: {
    imports = [
      self.program.niri
    ];

    options.compositor.type = lib.mkOption {
      type = lib.types.enum [ "niri" ];
      default = "niri";
      description = "Wayland compositor to use.";
    };

    options.desktop.session.type = lib.mkOption {
      type = lib.types.enum [ "wayland" "x11" ];
      default = if config.compositor.type == "niri" then "wayland" else "x11";
      description = "Canonical desktop session type for module-level decisions.";
    };

    config = lib.mkIf (config.compositor.type == "niri") {
      programs.niri.enable = true;
    };
  };
}

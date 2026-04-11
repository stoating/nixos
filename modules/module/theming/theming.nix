{ self, lib, ... }: {
  config.flake.homeModules.theming = { ... }: {
    imports = [
      self.homeModules.theming-gtk
      self.homeModules.theming-cursor
    ];
  };

  options.flake.theming.cursor = {
    name = lib.mkOption {
      type    = lib.types.str;
      default = "GoogleDot-Black";
    };
    size = lib.mkOption {
      type    = lib.types.int;
      default = 16;
    };
  };
}

{ self, ... }: {
  flake.homeModules.theming = { ... }: {
    imports = [
      self.homeModules.theming-gtk
    ];
  };
}

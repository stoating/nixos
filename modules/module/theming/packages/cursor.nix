{ ... }: {
  flake.homeModules.theming-cursor = { pkgs, config, lib, ... }: let
    # "catppuccin-mocha-dark-cursors" → pkgs.catppuccin-cursors.mochaDark
    catppuccinPkg = name:
      let
        inner       = lib.removePrefix "catppuccin-" (lib.removeSuffix "-cursors" name);
        parts       = lib.splitString "-" inner;
        flavor      = builtins.elemAt parts 0;
        accent      = builtins.elemAt parts 1;
        accentCamel = (lib.toUpper (builtins.substring 0 1 accent))
                    + (builtins.substring 1 (builtins.stringLength accent) accent);
      in pkgs.catppuccin-cursors.${flavor + accentCamel};

    packageForName = name:
      if      lib.hasPrefix "catppuccin-" name then catppuccinPkg name
      else if lib.hasPrefix "Bibata-"     name then pkgs.bibata-cursors
      else if lib.hasPrefix "Vimix-"      name then pkgs.vimix-cursors
      else    pkgs.google-cursor;
  in {
    options.theming.cursor = {
      name = lib.mkOption { type = lib.types.str; default = ""; };
      size = lib.mkOption { type = lib.types.int; default = 24;  };
    };

    config = lib.mkIf (config.theming.cursor.name != "") {
      home.pointerCursor = {
        name    = config.theming.cursor.name;
        package = packageForName config.theming.cursor.name;
        size    = config.theming.cursor.size;
        gtk.enable = true;
      };
    };
  };
}

{ inputs, lib, ... }: {
  options.flake.homeModules = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = {};
  };

  options.flake.lib = lib.mkOption {
    type    = lib.types.attrsOf lib.types.anything;
    default = {};
  };

config = {
    systems = [
      "x86_64-linux"
    ];

    perSystem = { system, ... }: {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    };
  };
}

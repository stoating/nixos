{ inputs, lib, ... }: {
  options.flake.program = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.unspecified;
    default = {};
  };

  options.flake.module = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.unspecified;
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

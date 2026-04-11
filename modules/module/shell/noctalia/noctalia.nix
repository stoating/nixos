{ self, inputs, ... }: {
  perSystem = { pkgs, system, ... }: {
    packages.noctalia = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      inherit pkgs;
      package = inputs.noctalia.packages.${system}.default;
      outOfStoreConfig = "/home/zack/.config/noctalia";
      settings =
        (builtins.fromJSON
          (builtins.readFile ./noctalia.json)).settings;
    };
  };
}

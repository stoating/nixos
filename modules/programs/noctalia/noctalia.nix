{ self, inputs, ... }: {
  perSystem = { pkgs, ... }: {
    packages.noctalia = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      inherit pkgs;
      settings = 
        (builtins.fromJSON
          (builtins.readFile ./noctalia.json)).settings;
    };
  };
}

{ self, ... }: {
  flake.homeModules.theming-bat = { pkgs, lib, config, ... }: {
    options.theming.bat.enable = lib.mkEnableOption "bat with themed output";

    config = lib.mkIf config.theming.bat.enable {
      programs.bat = {
        enable = true;
        config.theme = self.lib.theme.bat;
        themes."Ayu Mirage" = {
          src = pkgs.fetchFromGitHub {
            owner  = "dempfi";
            repo   = "ayu";
            rev    = "41e0098e8ce5014f1f90474a16bf31639f74fecf";
            sha256 = "123chvc94gwkvbyjs35cn650pgnf89riq6v5plx4yq126463ap4i";
          };
          file = "ayu-mirage.sublime-color-scheme";
        };
      };
    };
  };
}

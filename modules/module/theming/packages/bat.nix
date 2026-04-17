{ ... }: {
  flake.homeModules.theming-bat = { lib, config, ... }: {
    options.theming.bat.enable = lib.mkEnableOption "bat with themed output";

    config = lib.mkIf config.theming.bat.enable {
      programs.bat = {
        enable = true;
        config.theme = "Nord";
      };

    };
  };
}

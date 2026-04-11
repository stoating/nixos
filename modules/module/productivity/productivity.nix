{ self, ... }: {
  flake.homeModules.productivity = { lib, ... }: {
    imports = [
      self.homeModules.libreoffice
      self.homeModules.onlyoffice
      self.homeModules.wpsoffice
    ];

    options.productivity.programs = {
      libreoffice.enable = lib.mkEnableOption "LibreOffice";
      onlyoffice.enable  = lib.mkEnableOption "OnlyOffice Desktop Editors";
      wpsoffice.enable   = lib.mkEnableOption "WPS Office";
    };
  };
}

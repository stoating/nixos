{ self, ... }: {
  flake.homeModules.shell-tools = { lib, ... }: {
    imports = [
      self.homeModules.atuin
      self.homeModules.atuin-desktop
      self.homeModules.fzf
      self.homeModules.zoxide
      self.homeModules.navi
      self.homeModules.tldr
      self.homeModules.starship
      self.homeModules.comma
    ];

    options.shell-tools.programs = {
      atuin.enable         = lib.mkEnableOption "atuin";
      atuin-desktop.enable = lib.mkEnableOption "atuin desktop";
      fzf.enable           = lib.mkEnableOption "fzf";
      zoxide.enable        = lib.mkEnableOption "zoxide";
      navi.enable          = lib.mkEnableOption "navi";
      tldr.enable          = lib.mkEnableOption "tldr";
      starship.enable      = lib.mkEnableOption "starship";
      comma.enable         = lib.mkEnableOption "comma";
    };
  };
}

{ self, ... }: {
  flake.homeModules.media = { lib, ... }: {
    imports = [
      self.homeModules.asciinema
      self.homeModules.auto-editor
      self.homeModules.ffmpeg
      self.homeModules.discord
      self.homeModules.kdenlive
      self.homeModules.mpv
      self.homeModules.obs-studio
      self.homeModules.pear-desktop
      self.homeModules.rapid-photo-downloader
      self.homeModules.grim
      self.homeModules.slurp
      self.homeModules.wl-clipboard
    ];

    options.media.programs = {
      asciinema.enable    = lib.mkEnableOption "asciinema";
      auto-editor.enable  = lib.mkEnableOption "auto-editor";
      ffmpeg.enable       = lib.mkEnableOption "ffmpeg";
      discord.enable      = lib.mkEnableOption "Discord";
      kdenlive.enable     = lib.mkEnableOption "Kdenlive";
      mpv.enable          = lib.mkEnableOption "mpv";
      obs-studio.enable   = lib.mkEnableOption "OBS Studio";
      pear-desktop.enable = lib.mkEnableOption "Pear Desktop";
      rapid-photo-downloader.enable = lib.mkEnableOption "Rapid Photo Downloader";
      grim.enable         = lib.mkEnableOption "grim";
      slurp.enable        = lib.mkEnableOption "slurp";
      wl-clipboard.enable = lib.mkEnableOption "wl-clipboard";
    };
  };
}

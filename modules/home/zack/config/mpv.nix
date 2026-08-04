{ ... }: {
  flake.homeModules.zacks-mpv = { ... }: {
    # GNOME Showtime ("Video Player") ships a .desktop that claims video/*
    # but never maps a window under niri, so double-clicking a video in
    # Nautilus silently does nothing. Claiming the MIME types for mpv here
    # is what actually makes double-click work.
    xdg.mimeApps = {
      enable = true;

      defaultApplications = {
        "video/quicktime"   = "mpv.desktop";  # .MOV — the iPhone case
        "video/mp4"         = "mpv.desktop";  # .MP4/.M4V
        "video/x-matroska"  = "mpv.desktop";  # .mkv
        "video/webm"        = "mpv.desktop";
        "video/mpeg"        = "mpv.desktop";
        "video/x-msvideo"   = "mpv.desktop";  # .avi
        "video/3gpp"        = "mpv.desktop";
      };
    };
  };
}

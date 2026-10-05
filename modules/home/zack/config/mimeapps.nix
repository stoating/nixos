{ ... }: {
  flake.homeModules.zacks-mimeapps = { ... }: {
    # Single generated mimeapps.list, so all associations are declared here.
    xdg.mimeApps = {
      enable = true;

      defaultApplications = {
        "x-scheme-handler/http"         = "google-chrome.desktop";
        "x-scheme-handler/https"        = "google-chrome.desktop";
        "x-scheme-handler/about"        = "google-chrome.desktop";
        "x-scheme-handler/unknown"      = "google-chrome.desktop";
        "text/html"                     = "google-chrome.desktop";
        "x-scheme-handler/claude-cli"   = "claude-code-url-handler.desktop";
        "image/gif"                     = "org.gnome.Loupe.desktop";

        # GNOME Showtime claims video/* but never maps a window under niri,
        # so double-click in Nautilus silently does nothing without this.
        "video/quicktime"               = "mpv.desktop";
        "video/mp4"                     = "mpv.desktop";
        "video/x-matroska"              = "mpv.desktop";
        "video/webm"                    = "mpv.desktop";
        "video/mpeg"                    = "mpv.desktop";
        "video/x-msvideo"               = "mpv.desktop";
        "video/3gpp"                    = "mpv.desktop";
      };
    };
  };
}

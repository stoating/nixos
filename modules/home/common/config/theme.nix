{ ... }:
let
  # ── Change this to switch the entire system theme ──────────────────────────
  name = "Nord";

  themes = {
    Nord = {
      # Generic 16-color palette (Polar Night → Snow Storm → Frost → Aurora)
      colors = {
        c0  = "#2E3440"; # dark bg
        c1  = "#3B4252";
        c2  = "#434C5E";
        c3  = "#4C566A"; # light bg
        c4  = "#D8DEE9"; # dark fg
        c5  = "#E5E9F0";
        c6  = "#ECEFF4"; # light fg
        c7  = "#8FBCBB"; # teal
        c8  = "#88C0D0"; # light blue
        c9  = "#81A1C1"; # blue
        c10 = "#5E81AC"; # dark blue
        c11 = "#BF616A"; # red
        c12 = "#D08770"; # orange
        c13 = "#EBCB8B"; # yellow
        c14 = "#A3BE8C"; # green
        c15 = "#B48EAD"; # purple
      };
      ghostty  = "Nord";
      vscode   = "Nord";
      bat      = "Nord";
      delta    = "Nord";
      noctalia = "Nord";
      gtk      = "Nordic";
    };

    # Eldritch = {
    #   colors = { c0 = "#212337"; ... };
    #   ghostty  = "eldritch";
    #   vscode   = "Eldritch";
    #   bat      = "Eldritch";
    #   delta    = "Eldritch";
    #   noctalia = "Eldritch";
    #   gtk      = "Eldritch";
    # };
  };

  active = themes.${name};
in {
  flake.lib.theme = active // {
    inherit name;
    opacity = {
      terminal        = "0.9";
      editor          = "0.95";
      window-active   = "0.95";
      window-inactive = "0.90";
    };
  };
}

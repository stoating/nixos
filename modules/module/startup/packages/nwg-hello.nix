{ self, ... }: {
  flake.nixosModules.nwg-hello = { pkgs, lib, config, ... }:
  let
    cfg = config.startup.nwg-hello;
    nwg-hello-fixed = pkgs.nwg-hello.overrideAttrs (old: {
      postFixup = (old.postFixup or "") + ''
        substituteInPlace $out/lib/python*/site-packages/nwg_hello/main.py \
          --replace-fail "$out/etc/nwg-hello" "/etc/nwg-hello"
      '';
    });
    defaultSettings = {
      session_dirs = [
        "/run/current-system/sw/share/wayland-sessions"
        "/run/current-system/sw/share/xsessions"
      ];
      custom_sessions      = [];
      monitor_nums         = [];
      form_on_monitors     = [];
      delay_secs           = 1;
      cmd-sleep            = "systemctl suspend";
      cmd-reboot           = "systemctl reboot";
      cmd-poweroff         = "systemctl poweroff";
      gtk-theme            = self.lib.theme.gtk;
      gtk-icon-theme       = "";
      gtk-cursor-theme     = "";
      prefer-dark-theme    = true;
      template-name        = "";
      time-format          = "%H:%M:%S";
      date-format          = "%A, %d. %B";
      layer                = "overlay";
      keyboard-mode        = "on_demand";
      lang                 = "en_US";
      avatar-show          = false;
      avatar-size          = 100;
      avatar-border-width  = 1;
      avatar-border-color  = self.lib.theme.colors.c6;
      avatar-corner-radius = 15;
      avatar-circle        = false;
      env-vars             = [];
    };
    mergedSettings = lib.recursiveUpdate defaultSettings cfg.settings;
    defaultI18n = {
      failed-starting-session = "failed to start session";
      login                   = "login";
      login-failed            = "login failed";
      password                = "password";
      password-empty          = "password cannot be empty";
      power-off               = "power off";
      session                 = "session";
      show-password           = "show password";
      sleep                   = "sleep";
      reboot                  = "reboot";
      user                    = "user";
      welcome                 = "hello";
    };
    bgCss = lib.optionalString (cfg.background != null) ''
      window {
        background-color: transparent;
        background-image: url("file://${cfg.background}");
        background-size: auto 100%;
        background-repeat: no-repeat;
        background-position: center center;
      }
    '';
  in
  {
    config = lib.mkIf cfg.enable {
      environment = {
        pathsToLink = [ "/share/wayland-sessions" "/share/xsessions" ];
        etc = {
          "nwg-hello/sway-config".text = ''
            exec "${nwg-hello-fixed}/bin/nwg-hello --config /etc/nwg-hello/nwg-hello.json --stylesheet /etc/nwg-hello/nwg-hello.css; ${pkgs.sway}/bin/swaymsg exit"
          '';
          "nwg-hello/nwg-hello.json".text = builtins.toJSON mergedSettings;
          "nwg-hello/en_US".text         = builtins.toJSON (lib.recursiveUpdate defaultI18n cfg.i18n);
          "nwg-hello/nwg-hello.css".text = bgCss + cfg.css;
        };
      };

      users = {
        users.greeter = {
          isSystemUser = true;
          group        = "greeter";
          extraGroups  = [ "seat" "video" ];
        };
        groups.greeter = {};
      };

      services = {
        greetd = {
          enable = true;
          settings = {
            terminal.vt = 1;
            default_session = {
              command = "${pkgs.sway}/bin/sway --config /etc/nwg-hello/sway-config";
              user    = "greeter";
            };
          };
        };
        seatd.enable = true;
      };
    };
  };
}

{ self, ... }: {

  flake.nixosModules.framework-configuration = { pkgs, lib, config, ... }:
  let
    c = self.lib.theme.colors;
    nwg-hello-fixed = pkgs.nwg-hello.overrideAttrs (old: {
      postFixup = (old.postFixup or "") + ''
        substituteInPlace $out/lib/python*/site-packages/nwg_hello/main.py \
          --replace-fail "$out/etc/nwg-hello" "/etc/nwg-hello"
      '';
    });
    elegant-grub2-theme = pkgs.stdenv.mkDerivation {
      pname = "elegant-grub2-theme";
      version = "unstable-2026-04-21";

      src = pkgs.fetchFromGitHub {
        owner = "vinceliuice";
        repo  = "Elegant-grub2-themes";
        rev   = "92cdac334cf7bc5c1d68c2fbb266164653b4b502";
        hash  = "sha256-fbZLWHxnLBrqBrS2MnM2G08HgEM2dmZvitiCERie0Cc=";
      };

      installPhase = ''
        runHook preInstall

        mkdir -p $out

        # Fonts
        cp -a common/terminus*.pf2   $out/
        cp -a common/unifont-24.pf2  $out/

        # Background (forest, window, left, dark)
        cp -a backgrounds/backgrounds-forest/background-forest-window-left-dark.jpg $out/background.jpg

        # Icons
        cp -a assets/assets-icons-dark/icons-dark-2k $out/icons

        # Theme layout
        cp -a config/theme-window-left-dark-2k.txt $out/theme.txt

        # Selection decorations
        cp -a assets/assets-other/other-2k/select_e-forest-dark.png $out/select_e.png
        cp -a assets/assets-other/other-2k/select_c-forest-dark.png $out/select_c.png
        cp -a assets/assets-other/other-2k/select_w-forest-dark.png $out/select_w.png

        # Info panel decoration (window-left for non-forest-alt variant)
        cp -a assets/assets-other/other-2k/window-left.png $out/info.png

        # NixOS logo
        cp -a assets/assets-other/other-2k/Nixos.png $out/logo.png

        runHook postInstall
      '';
    };
  in
  {
    imports = [
      self.nixosModules.framework-hardware
      self.nixosModules.home-zack
    ];

    boot = {
      loader.efi.canTouchEfiVariables = true;
      loader.grub = {
        enable      = true;
        efiSupport  = true;
        device      = "nodev";
        theme       = elegant-grub2-theme;
        gfxmodeEfi  = "2560x1600,2560x1440,auto";
      };
      loader.timeout = 3;
      kernelPackages = pkgs.linuxPackages_latest;
      kernelParams = [ "quiet" "udev.log_level=3" "systemd.show_status=auto" ];
      consoleLogLevel = 3;
      initrd = {
        verbose = false;
        systemd.enable = true;
        luks.devices."luks-e13d7e39-2fc5-4ce4-8f3c-420e2197a26b".device =
          "/dev/disk/by-uuid/e13d7e39-2fc5-4ce4-8f3c-420e2197a26b";
      };
      plymouth = {
        enable = true;
        theme = "angular_alt";
        themePackages = with pkgs; [
          (adi1090x-plymouth-themes.override {
            selected_themes = [ "angular_alt" ];
          })
        ];
      };
    };

    networking = {
      firewall.enable = true;
      hostName = "fw";
      networkmanager.enable = true;
    };

    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [ "root" "zack" ];
      substituters = [
        "https://cache.nixos.org"
        "https://devenv.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      ];
    };

    time.timeZone = "Europe/Berlin";

    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
        LC_ADDRESS        = "de_DE.UTF-8";
        LC_IDENTIFICATION = "de_DE.UTF-8";
        LC_MEASUREMENT    = "de_DE.UTF-8";
        LC_MONETARY       = "de_DE.UTF-8";
        LC_NAME           = "de_DE.UTF-8";
        LC_NUMERIC        = "de_DE.UTF-8";
        LC_PAPER          = "de_DE.UTF-8";
        LC_TELEPHONE      = "de_DE.UTF-8";
        LC_TIME           = "de_DE.UTF-8";
      };
    };

    hardware.bluetooth = {
      enable       = true;
      powerOnBoot  = false;
    };

    # Keep xdg-desktop-portal from activating the GTK backend under niri.
    # It times out during startup and blocks first app launches, including Ghostty.
    xdg.portal.config.niri = {
      default = lib.mkForce [ "gnome" ];
      "org.freedesktop.impl.portal.Access" = lib.mkForce [ "gnome" ];
      "org.freedesktop.impl.portal.Notification" = lib.mkForce [ "gnome" ];
      "org.freedesktop.impl.portal.Inhibit" = lib.mkForce [ "none" ];
      "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
    };

    environment = {
      pathsToLink = [ "/share/wayland-sessions" "/share/xsessions" ];
      etc = {
        "nwg-hello/sway-config".text = ''
          output * bg /var/lib/greet/background.jpg fill
          exec "${nwg-hello-fixed}/bin/nwg-hello --config /etc/nwg-hello/nwg-hello.json --stylesheet /etc/nwg-hello/nwg-hello.css; ${pkgs.sway}/bin/swaymsg exit"
        '';
        "nwg-hello/nwg-hello.json".text = builtins.toJSON {
          session_dirs = [
            "/run/current-system/sw/share/wayland-sessions"
            "/run/current-system/sw/share/xsessions"
          ];
          custom_sessions   = [];
          monitor_nums      = [];
          form_on_monitors  = [];
          delay_secs        = 1;
          cmd-sleep         = "systemctl suspend";
          cmd-reboot        = "systemctl reboot";
          cmd-poweroff      = "systemctl poweroff";
          gtk-theme         = self.lib.theme.gtk;
          gtk-icon-theme    = "";
          gtk-cursor-theme  = "";
          prefer-dark-theme = true;
          template-name     = "";
          time-format       = "%H:%M:%S";
          date-format       = "%A, %d. %B";
          layer             = "overlay";
          keyboard-mode     = "on_demand";
          lang              = "en_US";
          avatar-show       = false;
          avatar-size       = 100;
          avatar-border-width  = 1;
          avatar-border-color  = c.c6;
          avatar-corner-radius = 15;
          avatar-circle        = false;
          env-vars             = [];
        };
        "nwg-hello/en_US".text = builtins.toJSON {
          failed-starting-session = "failed to start session";
          login = "login";
          login-failed = "login failed";
          password = "password";
          password-empty = "password cannot be empty";
          power-off = "power off";
          session = "session";
          show-password = "show password";
          sleep = "sleep";
          reboot = "reboot";
          user = "user";
          welcome = "hello";
        };
        "nwg-hello/nwg-hello.css".text = ''
          @define-color hello-bg #1F2430;
          @define-color hello-surface #2A313D;
          @define-color hello-surface-hover #343F4C;
          @define-color hello-surface-strong #232A35;
          @define-color hello-text #E6E1CF;
          @define-color hello-muted #CBCCC6;
          @define-color hello-accent #39BAE6;
          @define-color hello-accent-hover #4D98CC;
          @define-color hello-accent-soft rgba(57, 186, 230, 0.18);
          @define-color hello-accent-soft-hover rgba(57, 186, 230, 0.28);
          @define-color hello-border rgba(77, 152, 204, 0.58);
          @define-color hello-border-strong rgba(115, 208, 255, 0.82);

          /* Keep the wallpaper owned by sway so GTK never replaces it with the theme window color. */
          window {
            background-color: transparent;
            background-image: none;
          }

          /* Keep parent containers clear so the sway wallpaper shows through. */
          box {
            background-color: transparent;
            background-image: none;
          }

          #form-wrapper {
            background-color: rgba(31, 36, 48, 0.74);
            border-radius: 20px;
            border: 1px solid rgba(77, 152, 204, 0.24);
            padding: 22px;
            min-width: 320px;
          }

          entry {
            background-image: none;
            background-color: rgba(42, 49, 61, 0.88);
            color: @hello-text;
            caret-color: @hello-text;
            border: 1px solid @hello-border;
            border-radius: 18px;
            padding: 8px 12px;
            font-size: 24px;
            box-shadow: none;
            text-shadow: none;
          }

          entry:focus,
          entry:active {
            background-image: none;
            background-color: rgba(35, 42, 53, 0.94);
            color: @hello-text;
            border: 1px solid @hello-border-strong;
            box-shadow: none;
            outline: none;
          }

          button,
          button:hover,
          button:focus,
          button:active,
          button:checked {
            background-image: none;
            background-color: rgba(42, 49, 61, 0.88);
            color: @hello-text;
            border: 1px solid @hello-border;
            border-radius: 18px;
            padding: 8px 14px;
            font-size: 24px;
            box-shadow: none;
            text-shadow: none;
            outline: none;
            -gtk-icon-shadow: none;
          }

          button:hover {
            background-color: rgba(52, 63, 76, 0.94);
            border-color: @hello-border-strong;
          }

          button:focus,
          button:active,
          button:checked {
            background-color: rgba(35, 42, 53, 0.96);
            border-color: @hello-border-strong;
          }

          button label,
          button image {
            color: @hello-text;
            -gtk-icon-shadow: none;
          }

          #power-button {
            border-radius: 18px;
            background-image: none;
            background-color: rgba(42, 49, 61, 0.68);
            border: 1px solid rgba(77, 152, 204, 0.38);
            color: @hello-text;
            padding: 10px 16px;
            font-size: 26px;
          }

          #power-button:hover {
            background-color: rgba(52, 63, 76, 0.84);
            border-color: @hello-border-strong;
          }

          #power-button:active {
            background-color: rgba(57, 186, 230, 0.22);
            border-color: @hello-accent;
          }

          label {
            color: @hello-text;
            font-size: 24px;
          }

          checkbutton {
            color: @hello-muted;
            font-size: 24px;
          }

          checkbutton check {
            background-image: none;
            background-color: rgba(42, 49, 61, 0.88);
            border: 1px solid @hello-border;
            border-radius: 6px;
            box-shadow: none;
          }

          checkbutton check:checked,
          checkbutton check:hover,
          checkbutton check:focus {
            background-image: none;
            background-color: rgba(57, 186, 230, 0.24);
            border-color: @hello-border-strong;
          }

          combobox,
          combobox button,
          #form-combo {
            background-image: none;
            background-color: rgba(42, 49, 61, 0.88);
            color: @hello-text;
            border-radius: 18px;
            border: 1px solid @hello-border;
            font-size: 24px;
            box-shadow: none;
            text-shadow: none;
          }

          combobox box,
          combobox button box,
          combobox button label,
          combobox arrow {
            background-image: none;
            background-color: transparent;
            border: none;
            box-shadow: none;
            text-shadow: none;
          }

          #welcome-label {
            color: @hello-text;
            font-size: 56px;
            font-weight: 300;
          }

          #clock-label {
            color: #73D0FF;
            font-family: monospace;
            font-size: 40px;
            letter-spacing: 0.05em;
          }

          #date-label {
            color: @hello-muted;
            font-size: 28px;
          }

          #form-label {
            color: @hello-muted;
            font-size: 24px;
          }

          #form-combo {
            background-color: rgba(42, 49, 61, 0.88);
          }

          #password-entry {
            background-color: rgba(42, 49, 61, 0.88);
            color: @hello-text;
            font-size: 22px;
          }

          #login-button {
            background-image: none;
            background-color: @hello-accent-soft;
            color: @hello-text;
            border: 1px solid rgba(57, 186, 230, 0.52);
            border-radius: 18px;
            padding: 10px;
            font-size: 24px;
            margin-top: 4px;
            box-shadow: none;
            text-shadow: none;
            outline: none;
          }

          #login-button:hover,
          #login-button:focus {
            background-image: none;
            background-color: @hello-accent-soft-hover;
            border-color: @hello-accent-hover;
          }

          #login-button:active {
            background-image: none;
            background-color: rgba(77, 152, 204, 0.3);
            border-color: #73D0FF;
          }
        '';
      };
    };

    users = {
      users.greeter = {
        isSystemUser = true;
        group        = "greeter";
        extraGroups  = [ "seat" "video" ];
      };
      users.zack = {
        isNormalUser = true;
        description  = "zack";
        extraGroups  = [ "networkmanager" "wheel" "video" "docker" ];
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
      libinput.touchpad.naturalScrolling = true;
      xserver = {
        enable = true;
        xkb = {
          layout  = config.keyboard.xkb.layout;
          variant = config.keyboard.xkb.variant;
        };
      };
      desktopManager.gnome.enable = true;  # provides xdg-desktop-portal-gnome
      pulseaudio.enable = false;
      pipewire = {
        enable            = true;
        alsa.enable       = true;
        alsa.support32Bit = true;
        pulse.enable      = true;
      };
    };

    console = {
      keyMap = config.keyboard.xkb.layout;
      font = "ter-v32n";
      packages = [ pkgs.terminus_font ];
      earlySetup = true;
    };

    security = {
      rtkit.enable = true;
      sudo.wheelNeedsPassword = true;
    };

    virtualisation = {
      docker.enable = true;
      podman.enable = true;
    };

    systemd.tmpfiles.rules = [
      "d /var/cache/nwg-hello 0750 greeter greeter -"
    ];

    systemd.settings.Manager.DefaultTimeoutStopSec = "5s";

    nix.gc = {
      automatic = true;
      dates     = "weekly";
      options   = "--delete-older-than 30d";
    };

    system.activationScripts.greet-background.text = ''
      dest=/var/lib/greet/background.jpg
      src=/home/zack/pictures/wallpapers/daniel-leone-v7daTKlZzaw-unsplash.jpg
      if [ ! -f "$dest" ]; then
        mkdir -p /var/lib/greet
        cp "$src" "$dest"
      fi
    '';

    nixpkgs.config.allowUnfree = true;

    system.stateVersion = "25.11";
  };
}

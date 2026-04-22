{ self, ... }: {

  flake.nixosModules.framework-configuration = { pkgs, lib, config, ... }:
  let
    colors = self.lib.theme.colors;
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
        timeout     = 3;
      };
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

    programs.regreet = {
      enable = true;

      settings = {
        background = {
          path = "/var/lib/regreet/background.jpg";
          fit  = "Cover";
        };
        GTK.application_prefer_dark_theme = true;
      };

      extraCss = ''
        /* Login and clock frames */
        frame.background {
          background-color: alpha(${colors.c0}, 0.88);
          border-color: alpha(${colors.c3}, 0.6);
          border-radius: 12px;
        }

        frame.background > * {
          background-color: transparent;
        }

        label {
          color: ${colors.c4};
        }

        /* Text entries and password entry */
        entry {
          background-color: ${colors.c1};
          color: ${colors.c4};
          border-color: ${colors.c3};
          caret-color: ${colors.c9};
        }

        entry:focus {
          border-color: ${colors.c9};
        }

        /* User / session combo boxes */
        combobox > button {
          background-color: ${colors.c1};
          color: ${colors.c4};
          border-color: ${colors.c3};
        }

        combobox > button:hover {
          background-color: ${colors.c2};
          color: ${colors.c6};
        }

        /* Login button */
        button.suggested-action {
          background-color: ${colors.c9};
          color: ${colors.c0};
          font-weight: bold;
        }

        button.suggested-action:hover {
          background-color: ${colors.c8};
        }

        /* Cancel button */
        button.text-button {
          background-color: ${colors.c2};
          color: ${colors.c4};
          border-color: ${colors.c3};
        }

        button.text-button:hover {
          background-color: ${colors.c3};
          color: ${colors.c6};
        }

        /* Edit-toggle buttons (pencil icons) */
        togglebutton {
          background-color: ${colors.c1};
          color: ${colors.c4};
          border-color: ${colors.c3};
        }

        togglebutton:checked {
          background-color: ${colors.c9};
          color: ${colors.c0};
        }

        /* Reboot / Power Off */
        button.destructive-action {
          background-color: alpha(${colors.c11}, 0.85);
          color: ${colors.c0};
          font-weight: bold;
        }

        button.destructive-action:hover {
          background-color: ${colors.c11};
        }

        /* Error info bar */
        infobar {
          background-color: alpha(${colors.c11}, 0.15);
          border-color: alpha(${colors.c11}, 0.5);
        }

        infobar label {
          color: ${colors.c11};
        }
      '';
    };

    system.activationScripts.regreet-wallpaper.text = ''
      src=/home/zack/pictures/wallpapers/daniel-leone-v7daTKlZzaw-unsplash.jpg
      dst=/var/lib/regreet/background.jpg
      if [ -f "$src" ] && { [ ! -f "$dst" ] || [ "$src" -nt "$dst" ]; }; then
        install -Dm644 "$src" "$dst"
      fi
    '';

    services = {
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

    console.keyMap = config.keyboard.xkb.layout;

    security = {
      rtkit.enable = true;
      sudo.wheelNeedsPassword = true;
    };

    virtualisation = {
      docker.enable = true;
      podman.enable = true;
    };

    systemd.settings.Manager.DefaultTimeoutStopSec = "5s";

    nix.gc = {
      automatic = true;
      dates     = "weekly";
      options   = "--delete-older-than 30d";
    };

    users.users.zack = {
      isNormalUser = true;
      description  = "zack";
      extraGroups  = [ "networkmanager" "wheel" "video" "docker" ];
    };

    nixpkgs.config.allowUnfree = true;

    system.stateVersion = "25.11";
  };
}

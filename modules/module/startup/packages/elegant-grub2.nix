{ ... }: {
  flake.nixosModules.elegant-grub2 = { pkgs, lib, config, ... }:
  let
    elegant-grub2-theme = pkgs.stdenv.mkDerivation {
      pname   = "elegant-grub2-theme";
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
  in {
    config = lib.mkIf (config.startup.grub.theme == "elegant-grub2") {
      boot.loader = {
        efi.canTouchEfiVariables = true;
        timeout                  = config.startup.grub.timeout;
        grub = {
          enable     = true;
          efiSupport = true;
          device     = "nodev";
          gfxmodeEfi = config.startup.grub.gfxmodeEfi;
          theme      = elegant-grub2-theme;
        };
      };
    };
  };
}

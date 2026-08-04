{ ... }: {
  flake.nixosModules.iphone = { pkgs, lib, config, ... }: {
    options.iphone = {
      enable = lib.mkEnableOption "iPhone/iPad USB access (photo + file transfer over USB)";
    };

    config = lib.mkIf config.iphone.enable {
      # usbmuxd negotiates the data session with the phone. Without it the
      # host never opens a lockdownd connection, so iOS assumes "dumb charger"
      # and never shows the "Trust This Computer" prompt.
      services.usbmuxd.enable = true;

      # gvfs' afc backend lets gvfs-aware file managers show the iPhone as a
      # mountable "drive" (Files/Dolphin/Thunar sidebar).
      services.gvfs.enable = true;

      environment.systemPackages = with pkgs; [
        libimobiledevice # idevicepair / ideviceinfo / afc tooling
        ifuse            # FUSE mount of the phone's DCIM + docs (~/iphone)
        gphoto2          # PTP pull of photos/videos straight from DCIM
      ];
    };
  };
}

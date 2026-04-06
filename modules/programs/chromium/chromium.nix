{ ... }: {
  flake.program.chromium = { pkgs, ... }: {
    programs.chromium = {
      package = pkgs.chromium;
      commandLineArgs = [
        "--enable-features=WaylandWindowDecorations"
        "--ozone-platform-hint=auto"
      ];
      nativeMessagingHosts = [
        pkgs.keepassxc
      ];
      extensions = [
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
        { id = "oboonakemofpalcgghocfoadofidjkkk"; } # KeePassXC-Browser
        { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark Reader
      ];
    };
  };
}

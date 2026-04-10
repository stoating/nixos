{ ... }: {
  flake.homes.zack.chromium = { ... }: {
    programs.chromium.extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
      { id = "oboonakemofpalcgghocfoadofidjkkk"; } # KeePassXC-Browser
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark Reader
    ];
  };
}

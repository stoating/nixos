{ ... }: {
  flake.nixosModules.zacks-keyboard = { ... }: {
    keyboard.xkb = {
      layout  = "de";
      variant = "";
    };
  };
}

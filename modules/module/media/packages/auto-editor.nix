{ ... }: {
  flake.homeModules.auto-editor = { pkgs, lib, config, ... }: {
    home.packages = lib.mkIf config.media.programs.auto-editor.enable [
      pkgs.auto-editor
    ];
  };
}

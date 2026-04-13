{ ... }: {
  flake.homeModules.emacs = { lib, config, ... }: {
    programs.emacs = lib.mkIf config.editor.programs.emacs.enable {
      enable = true;
    };
  };
}

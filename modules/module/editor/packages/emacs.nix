{ ... }: {
  flake.homeModules.emacs = { lib, config, ... }: {
    programs.emacs.enable = lib.mkIf config.editor.programs.emacs.enable true;
  };
}

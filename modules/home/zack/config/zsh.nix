{ ... }: {
  flake.homeModules.zacks-zsh = { ... }: {
    programs.zsh = {
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      initContent = ''
        export MANPAGER="sh -c 'col -bx | bat -l man -p'"
        export MANROFFOPT="-c"
      '';
    };
  };
}

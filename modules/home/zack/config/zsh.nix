{ ... }: {
  flake.nixosModules.zacks-zsh = { ... }: {
    programs.zsh = {
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      interactiveShellInit = ''
        export MANPAGER="sh -c 'col -bx | bat -l man -p'"
        export MANROFFOPT="-c"
      '';
    };
  };
}

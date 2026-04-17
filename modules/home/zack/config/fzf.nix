{ ... }: {
  flake.homeModules.zacks-fzf = { ... }: {
    programs.fzf = {
      fileWidgetOptions = [
        "--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
      ];
    };
  };
}

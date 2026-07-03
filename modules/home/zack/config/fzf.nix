{ ... }: {
  flake.homeModules.zacks-fzf = { ... }: {
    programs.fzf = {
      fileWidget.options = [
        "--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
      ];
      historyWidget.command = "";
    };
  };
}

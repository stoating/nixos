{ self, ... }: {
  flake.homeModules.development = { lib, ... }: {
    imports = [
      self.homeModules.git
      self.homeModules.gh
      self.homeModules.lazygit
      self.homeModules.direnv
      self.homeModules.devenv
      self.homeModules.delta
      self.homeModules.python
      self.homeModules.uv
      self.homeModules.clojure
      self.homeModules.nodejs
      self.homeModules.jdk
      self.homeModules."clj-kondo"
    ];

    options.development = {
      programs = {
        git.enable     = lib.mkEnableOption "Git";
        gh.enable      = lib.mkEnableOption "GitHub CLI";
        lazygit.enable = lib.mkEnableOption "Lazygit";
        direnv.enable  = lib.mkEnableOption "direnv";
        devenv.enable  = lib.mkEnableOption "devenv";
        delta.enable   = lib.mkEnableOption "delta";
      };
      languages = {
        python.enable     = lib.mkEnableOption "Python 3";
        uv.enable         = lib.mkEnableOption "uv";
        clojure.enable    = lib.mkEnableOption "Clojure";
        nodejs.enable     = lib.mkEnableOption "Node.js";
        jdk.enable        = lib.mkEnableOption "JDK";
        "clj-kondo".enable = lib.mkEnableOption "clj-kondo";
      };
    };
  };
}

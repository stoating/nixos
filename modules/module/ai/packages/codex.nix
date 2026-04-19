{ ... }: {
  flake.homeModules.codex = { lib, config, pkgs, ... }: {
    home.packages = lib.mkIf config.ai.programs.codex.enable [
      (pkgs.codex.overrideAttrs (old: rec {
        version = "0.121.0";
        src = pkgs.fetchFromGitHub {
          owner = "openai";
          repo = "codex";
          tag = "rust-v${version}";
          hash = "sha256-wjiUMox9V5tFggNgaFyHXWhRlpPerK7W+U/eR2Ddbbc=";
        };
        cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
          inherit src;
          sourceRoot = "${src.name}/codex-rs";
          hash = "sha256-zpQ0vg9XuarLfdZYiRIhcwLHUOdunNbOb5xLW3MPzp8=";
        };
      }))
    ];

  };
}

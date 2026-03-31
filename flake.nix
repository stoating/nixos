{
  description = "nixos config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    
    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";
    noctalia-shell.url = "github:noctalia-dev/noctalia-shell/v4.7.2";
  };

  # import modules/ automatically
  outputs = inputs: inputs.flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree ./modules);
}

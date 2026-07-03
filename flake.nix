{
  description = "nixos config";

  nixConfig = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";
    noctalia.url = "github:noctalia-dev/noctalia-shell/v4.7.2";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    claude-desktop.url = "github:k3d3/claude-desktop-linux-flake";
    nixos-management-skill.url = "github:michalzubkowicz/nixos-management-skill";
    nixos-management-skill.flake = false;

    # To pin VSCode: replace with url = "github:nixos/nixpkgs/<commit>";
    vscode.follows = "nixpkgs";
  };

  # import modules/ automatically
  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; }
      (inputs.import-tree ./modules);
}

{ self, inputs, ... }: {

  flake.nixosModules.home-zack = { pkgs, lib, ... }: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.zack = {
        imports = [
          self.homeModules.vscode
          self.homeModules.chrome
        ];

        home.stateVersion = "25.11";
      };
    };
  };

}

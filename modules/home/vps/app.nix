{ inputs, ... }: {

  # Minimal home-manager presence for the 'app' system user.
  # This user has no login shell; this module exists only to pin stateVersion
  # and lay down any dotfiles the app process needs (e.g. JVM flags, env files).

  flake.nixosModules.home-vps-app = { ... }: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];

    home-manager = {
      useGlobalPkgs   = true;
      useUserPackages = true;
      users.app = {
        # Add any app-process dotfiles here if needed.
        home.stateVersion = "25.11";
      };
    };
  };

}

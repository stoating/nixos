{ self, ... }: {

  flake.nixosModules.quote-assistant-configuration = { pkgs, ... }: {
    imports = [
      self.nixosModules.home-vps-admin
      self.nixosModules.home-vps-app
    ];

    boot.loader.grub = {
      enable  = true;
      device  = "/dev/sda";
    };

    networking = {
      hostName = "quote-assistant";
      firewall = {
        enable          = true;
        allowedTCPPorts = [ 22 80 443 ];
      };
    };

    nix.settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users         = [ "root" "admin" ];
    };

    time.timeZone = "Europe/Berlin";

    i18n.defaultLocale = "en_US.UTF-8";

    services = {
      openssh = {
        enable               = true;
        settings = {
          PasswordAuthentication = false;
          PermitRootLogin        = "no";
        };
      };

      nginx = {
        enable = true;
        recommendedGzipSettings  = true;
        recommendedOptimisation  = true;
        recommendedProxySettings = true;
        recommendedTlsSettings   = true;

        virtualHosts."quote-assistant" = {
          locations."/" = {
            proxyPass = "http://127.0.0.1:3000";
          };
        };
      };
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "zack@example.com";
    };

    home-manager.users.admin.home.stateVersion = "25.11";

    # Admin user — SSH access + sudo for managing the server
    users.users.admin = {
      isNormalUser  = true;
      extraGroups   = [ "wheel" ];
      shell         = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        # Add your SSH public key here
      ];
    };

    programs.zsh.enable = true;

    # App service user — runs the Clojure process, no login shell
    users.users.app = {
      isSystemUser = true;
      group        = "app";
      home         = "/var/lib/quote-assistant";
      createHome   = true;
    };
    users.groups.app = {};

    systemd.services.quote-assistant = {
      description = "Quote Assistant web app";
      wantedBy    = [ "multi-user.target" ];
      after       = [ "network.target" ];

      serviceConfig = {
        User             = "app";
        Group            = "app";
        WorkingDirectory = "/var/lib/quote-assistant";
        # Update ExecStart to match your jar name / uberjar path after building
        ExecStart        = "${pkgs.jdk}/bin/java -jar /var/lib/quote-assistant/app.jar";
        Restart          = "on-failure";
        RestartSec       = "5s";
      };
    };

    nixpkgs.config.allowUnfree = true;

    system.stateVersion = "25.11";
  };

}

# modules/nixos/features/foundation-nixos-config/default.nix
# NOTE
# Ideally all machines: under-powered machines, sbc's, routers, printers, all nixos related machines.
{
  lib,
  pkgs,
  inputs,
  namespace,
  system,
  target,
  format,
  virtual,
  systems,
  config,
  ...
}: let
  cfg = config.profiles.${namespace}.my.nixos.features.foundation-nixos-config;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.nixos.features.foundation-nixos-config = {
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'features', of module 'foundation-nixos-config', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    profiles.${namespace}.my.nixos = {
      features = {
        myVars = enabled;
        vm-boot-compatible = enabled;
      };
      programs = {
        openssh = enabled;
      };
    };

    system.stateVersion = "25.11";

    nixpkgs.config.allowUnfree = true;
    nix.settings.auto-optimise-store = true; # Optimize store every build. May slow down rebuilds
    nix.settings.download-buffer-size = 9024288000; # 9 GB

    boot.supportedFilesystems = ["zfs"];
    time.hardwareClockInLocalTime = true; # TODO this is in desktop too.
    time.timeZone = "America/New_York";

    networking = {
      hostName = "${config.myVars.hostname}"; # Define your hostname.
      # nameservers = [ "8.8.8.8" "8.8.4.4" ];
      dhcpcd.enable = true;
      # domain = "home";
      firewall = {
        # enable = false;
        # always allow traffic from your Tailscale network
        trustedInterfaces = ["tailscale0"];
        # Open the necessary UDP ports for PXE boot
        allowedUDPPorts = [
          67
          69
          4011
          41641 # tailscale UDP port
        ];
        # Open the necessary TCP port for Pixiecore
        allowedTCPPorts = [
          22
          80
          64172
          8787
          443 # tailscale TCP port
        ];
        allowPing = true; # Optional: Allow ICMP (ping)
        # Set default policies to 'accept' for both incoming and outgoing traffic
      };
      # firewall.allowedUDPPorts = [ 67 69 4011 ];
      # firewall.allowedTCPPorts = [ 64172 ];
    };

    users = {
      # Define a user account. Don't forget to set a password with 'passwd'.
      mutableUsers = false; # Required for a password 'passwd' to be set via sops during system activation (over anything done imperatively)!
      users.root.initialHashedPassword = lib.mkForce null; # force it and override ISO installer module
      users.root.hashedPasswordFile = config.sops.secrets.user_password.path;
      users.${config.myVars.username} = {
        hashedPasswordFile = config.sops.secrets.user_password.path;
        isNormalUser = true;
        extraGroups = ["wheel"];
        ignoreShellProgramCheck = true;
      };
    };

    nix.settings.experimental-features = ["nix-command" "flakes"];
    nix.settings.allowed-uris = [
      "github:"
      "git+https://github.com/"
      "git+ssh://github.com/"
      "git+ssh://git@github.com/" # My secrets repository
      "git+ssh://git@github.com/danielgomez3/nix-secrets.git"
    ];

    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };
}

# base-nixos-config.nix
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
  cfg = config.profiles.${namespace}.my.nixos.features.base-nixos-config;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.nixos.features.base-nixos-config = {
    enable = mkEnableOption "Enable custom module for platform 'nixos', of category 'features', of module 'base-nixos-config', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
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

    system.stateVersion = "25.11";

    users = {
      # Define a user account. Don't forget to set a password with 'passwd'.
      mutableUsers = false; # Required for a password 'passwd' to be set via sops during system activation (over anything done imperatively)!
      users.root.initialHashedPassword = lib.mkForce null; # force it and override ISO installer module
      users.root.hashedPasswordFile = config.sops.secrets.user_password.path;
      users.${config.myVars.username} = {
        hashedPasswordFile = config.sops.secrets.user_password.path;
        isNormalUser = true;
        extraGroups = ["wheel"];
        shell = pkgs.zsh;
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

    nix.settings.auto-optimise-store = true; # Optimize store every build. May slow down rebuilds
    nix.settings.download-buffer-size = 9024288000; # 9 GB
    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      vim
      git
      wget
      curl
      pigz
      nftables
      iptables
      unixtools.netstat
      toybox
      busybox # telnet,
      openssl
      dig # check dns records
      mailutils # send mail via 'mail'
      sysz
      wireguard-tools
      fd
      procps
      file
      efibootmgr # for forcing dual-boot in cli
      lm_sensors
      gnutar
      arp-scan # this one is sick: arp-scan --localnet
      nmap # even better: nmap -sn <ip>/24
      procs # view processes, cpu usage, and memory. Like btop and ps aux had a baby
      uutils-coreutils-noprefix # updated version of 'dd' with progress param.
      grc # colorize can cmd: grc nmap
      gptfdisk
      direnv
      just
    ];
  };
}

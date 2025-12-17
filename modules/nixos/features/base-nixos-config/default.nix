# base-nixos-config.nix
# NOTE
# NOT low powered resource constrained machines, but ideally every machine.
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
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    users.users.${config.myVars.username}.shell = pkgs.zsh;
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

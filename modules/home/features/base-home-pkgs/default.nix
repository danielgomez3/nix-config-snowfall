# modules/home/features/base-home-pkgs/default.nix
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
  cfg = config.profiles.${namespace}.my.home.features.base-home-pkgs;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.home.features.base-home-pkgs = {
    enable = mkBoolOpt false "Enable custom module for platform 'home', of category 'features', of module 'base-home-pkgs', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    home.packages = let
      cyberPkgs = with pkgs; [
        age
        aria2
      ];
      networkPkgs = with pkgs; [
        vim
        git
        wget
        curl
        nftables
        iptables
        toybox # contains gnutar, ..
        busybox # telnet, ..
        openssl
        dig # check dns records
        mailutils # send mail via 'mail'
        wireguard-tools
        arp-scan # this one is sick: arp-scan --localnet
        nmap # even better: nmap -sn <ip>/24
      ];
      nixCliPkgs = with pkgs; [
        just
        nix-tree
        disko
        nixos-anywhere
      ];
      cliPkgs = with pkgs; [
        procs # view processes, cpu usage, and memory. Like btop and ps aux had a baby
        pigz
        procps
        sysz
        fd
        file
        uutils-coreutils-noprefix # updated version of 'dd' with progress param.
        grc # colorize a cmd: grc nmap
        nushell
      ];
      hardwarePkgs = with pkgs; [
        jmtpfs # For interfacing with my OP-1 Field.
        woeusb
        ntfs3g
        efibootmgr # for forcing dual-boot in cli
        gptfdisk
        lm_sensors
      ];
      funPkgs = with pkgs; [
        cmatrix
      ];
    in
      lib.concatLists [
        cyberPkgs
        networkPkgs
        cliPkgs
        hardwarePkgs
        nixCliPkgs
        funPkgs
      ];
  };
}

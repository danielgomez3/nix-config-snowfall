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
  inherit (lib.${namespace}) enabled genHostId;
in {
  options.profiles.${namespace}.my.nixos.features.base-nixos-config = {
    enable = mkEnableOption "Enable custom module for platform 'nixos', of category 'features', of module 'base-nixos-config', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    # Give everyone a special ZFS linux kernel to use or deploy a zfs system.
    boot.supportedFilesystems = ["zfs"];
    networking.hostId = genHostId config.myVars.hostname; # that means you also need to have a hostId, even if you're not using zfs.

    # boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_17; # Change kernel if needed to support different file systems
    users.users.${config.myVars.username}.shell = pkgs.zsh;
    # TODO: move to wezterm for home manager solution
    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
      font-awesome_5
      nerd-fonts.fira-code
    ];
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

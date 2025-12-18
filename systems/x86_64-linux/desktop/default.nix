# systems/x86_64-linux/desktop/default.nix
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
  inherit (lib.${namespace}) enabled;
in {
  imports = [
    ./hardware-configuration.nix
    # inputs.nixos-facter-modules.nixosModules.facter
    # {config.facter.reportPath = ./facter.json;}
  ];

  myVars.username = "daniel";
  myVars.hostname = "desktop";

  profiles.${namespace}.my.nixos = {
    # disko.zfs-only-ephemeral = {
    #   enable = true;
    #   encryption = false;
    #   blockDevice = "/dev/nvme0n1";
    #   swap = {
    #     enable = true;
    #     swapPartSize = "16G";
    #   };
    # };
    # disko.bios-uefi-gpt = {
    #   enable = true;
    #   blockDevice = "/dev/nvme0n1";
    #   swapPart = {
    #     enable = true;
    #     size = "16G";
    #   };
    #   dualBoot = enabled;
    #   # windowsPartSize = "500G";
    #   linuxPartSize = "1000G";
    # };
    # disko.dual-boot-generic = {
    #   enable = true;
    #   blockDevice = "/dev/nvme0n1";
    #   # swapPart = {
    #   #   enable = true;
    #   #   size = "16G";
    #   # };
    #   dualBoot = enabled;
    #   windowsPartSize = "800G";
    #   linuxPartSize = "1000G";
    # };
    disko.simple-efi = {
      enable = true;
      blockDevice = "/dev/nvme0n1";
    };
    bundles = {
      x86-64-uefi-boot = enabled;
      base-minimal-nixos = enabled;
      gui-desktop-environment = enabled;
      desktop-gaming = enabled;
    };
    features = {
      amd-gpu = enabled;
      yubikey-gui-functionality = enabled;
      embedded-dev-environment = enabled;
      rdp-client-gnome = enabled;
    };
    programs = {
      discord = enabled;
      docker = enabled;
      retroarch = enabled;
      flatpak = enabled;
    };
  };
}

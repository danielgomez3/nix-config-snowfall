# systems/x86_64-linux/steam-machine/default.nix
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
  myVars.hostname = "steam-machine";

  users.users.${config.myVars.username} = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  profiles.${namespace}.my.nixos = {
    # disko.bios-uefi-gpt = {
    #   enable = true;
    #   dualBoot = enabled;
    #   linuxPartSize = "300G";
    #   swapPart = {
    #     enable = true;
    #     size = "16G";
    #   };
    #   blockDevice = "/dev/nvme0n1";
    # };
    # disko.luks-ephemeral-btrfs = {
    #   enable = true;
    #   dualBoot = enabled;
    #   linuxPartSize = "300G";
    #   swapPart = {
    #     enable = true;
    #     size = "16G";
    #   };
    #   blockDevice = "/dev/nvme0n1";
    # };
    # disko.zfs-ephemeral = {
    #   enable = true;
    # };
    disko.zfs-only-ephemeral = {
      enable = true;
      blockDevice = "/dev/nvme0n1p1";
    };
    bundles = {
      x86-64-uefi-boot = enabled;
      core-minimal-nixos = enabled;
      # gui-desktop-environment = enabled;
    };
    # EXPLICITLY disable persistence if not needed
    features = {
      jovian-nixos = enabled;
      netbootxyz = enabled;
    };
    programs = {
    };
  };
}

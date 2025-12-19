# systems/x86_64-linux/server/default.nix
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
    # {config.facter.reportPath = ./facter.json;}
    # inputs.nixos-facter-modules.nixosModules.facter
    # {config.facter.reportPath = ./facter.json;}
  ];

  myVars.username = "daniel";
  myVars.hostname = "server";

  profiles.${namespace}.my.nixos = {
    disko.ephemeral-zfs-luks = {
      enable = true;
      zfs = {
        enable = true;
        root = {
          encrypt = true;
          disk1 = "nvme0n1";
        };
      };
      initrd-ssh = {
        enable = true;
        ethernetDrivers = ["r8169"];
      };
    };
    bundles = {
      x86-64-uefi-boot = enabled;
      base-minimal-nixos = enabled;
    };
    features = {
      wireguard-client.enable = true; # Maybe add to base-system.nix
      # minecraft-server-docker.enable = true;
      # macos-emulation.enable = false;
    };
    programs = {
      # plex = enabled;
    };
  };
}

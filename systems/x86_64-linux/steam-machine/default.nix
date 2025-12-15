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
    disko.zfs-only-ephemeral = {
      enable = true;
      encryption = false;
      blockDevice = "/dev/nvme0n1";
      swap = {
        enable = true;
        swapPartSize = "16G";
      };
    };
    bundles = {
      x86-64-uefi-boot = enabled;
      base-minimal-nixos = enabled;
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

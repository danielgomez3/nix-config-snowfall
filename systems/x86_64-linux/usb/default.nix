# systems/x86_64-linux/usb/default.nix
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
    # ./hardware-configuration.nix
    # inputs.nixos-facter-modules.nixosModules.facter
    # {config.facter.reportPath = ./facter.json;}
  ];

  myVars.username = "daniel";
  myVars.hostname = "usb";

  users.users.${config.myVars.username} = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  profiles.${namespace}.my.nixos = {
    disko.zfs-only-ephemeral = {
      enable = true;
      encryption = true;
      blockDevice = "/dev/sda";
      swap = {
        enable = true;
        swapPartSize = "16G";
      };
    };

    bundles = {
      x86-64-uefi-boot = enabled;
      base-minimal-nixos = enabled;
    };
    features = {
    };
    programs = {
    };
  };
}

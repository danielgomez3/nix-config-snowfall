# systems/x86_64-iso/minimal/default.nix
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
  myVars.hostname = "minimal";

  users.users.${config.myVars.username} = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  profiles.${namespace}.my.nixos = {
    # disko.zfs-only-ephemeral = {
    #   enable = true;
    #   encryption = false;
    #   blockDevice = "/dev/sda";
    #   swap = {
    #     enable = true;
    #     swapPartSize = "16G";
    #   };
    # };

    disko.luks-persist-usb = enabled;

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

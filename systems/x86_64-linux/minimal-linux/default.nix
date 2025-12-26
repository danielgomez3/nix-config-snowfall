# systems/x86_64-linux/minimal-linux/default.nix
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
  myVars.hostname = "minimal-linux";

  users.users.${config.myVars.username} = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  profiles.${namespace}.my.nixos = {
    disko.simple-efi = {
      enable = true;
      blockDevice = "/dev/nvme0n1";
    };

    bundles = {
      x86-64-uefi-boot = enabled;
      base-minimal-nixos = enabled;
      gui-desktop-environment = enabled;
    };
    features = {
    };
    programs = {
    };
  };
}

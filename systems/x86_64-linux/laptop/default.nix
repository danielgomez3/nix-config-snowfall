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
  myVars.hostname = "laptop";

  users.users.${config.myVars.username} = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  profiles.${namespace}.my.nixos = {
    disko.luks-lvm-gpt = {
      enable = true;
      blockDevice = "/dev/sda";
    };
    bundles = {
      x86-64-uefi-boot = enabled;
      base-minimal-nixos = enabled;
      gui-desktop-environment = enabled;
    };
    features = {
      laptop-device-settings = enabled;
    };
    programs = {
      #   plex.enable = true;
      nix-software-center = enabled;
    };
  };
}

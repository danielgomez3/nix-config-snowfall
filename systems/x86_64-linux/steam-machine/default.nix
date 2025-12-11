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
    disko.dual-boot-generic = {
      enable = true;
      blockDevice = "/dev/nvme0n1";
    };
    # disko.dual-boot-impermanence = {
    #   enable = true;
    #   blockDevice = "/dev/nvme0n1";
    #   persistentStorageSize = "50G"; # Adjust based on your needs
    # };
    bundles = {
      x86-64-uefi-boot = enabled;
      core-minimal-nixos = enabled;
      # gui-desktop-environment = enabled;
    };
    features = {
      jovian-nixos = enabled;
      netbootxyz = enabled;
      # persistence = enabled;
    };
    programs = {
    };
  };
}

# systems/x86_64-linux/testmachine/default.nix
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
  myVars.hostname = "testmachine";

  users.users.${config.myVars.username} = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  profiles.${namespace}.my.nixos = {
    disko.bios-uefi-gpt = {
      enable = true;
      blockDevice = "/dev/sda";
    };
    bundles = {
      x86-64-uefi-boot = enabled;
      core-minimal-nixos = enabled;
    };
    features = {
    };
    programs = {
    };
  };
}

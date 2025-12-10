# systems/xxplatformxx/xxhostxx/default.nix
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

  myVars.username = "xxusernamexx";
  myVars.hostname = "xxhostxx";

  users.users.${config.myVars.username} = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  profiles.${namespace}.my.nixos = {
    disko.bios-uefi-gpt = {
      enable = true;
      blockDevice = "xxblock_devicexx";
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

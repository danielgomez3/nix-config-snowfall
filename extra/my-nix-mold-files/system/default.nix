# systems/__platform__/__host__/default.nix
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

  myVars.username = "__username__";
  myVars.hostname = "__host__";

  users.users.${config.myVars.username} = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  profiles.${namespace}.my.nixos = {
    disko.zfs-only-ephemeral = {
      enable = true;
      encryption = false;
      blockDevice = "__block_device__";
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

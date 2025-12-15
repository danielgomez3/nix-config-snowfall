# systems/x86_64-linux/desktop/default.nix
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
  myVars.hostname = "desktop";

  users.users.${config.myVars.username} = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  profiles.${namespace}.my.nixos = {
    disko.luks-ephemeral-btrfs = {
      enable = true;
      dualBoot = false;
      linuxPartSize = "100%";
      swapPart = {
        enable = true;
        size = "16G";
      };
      blockDevice = "/dev/nvme0n1";
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

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
  myVars.hostname = "laptop";

  users.users.${config.myVars.username} = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  profiles.${namespace}.my.nixos = {
    disko.zfs-only-ephemeral = {
      enable = true;
      encryption = true;
      blockDevice = "/dev/sdb";
      swap = {
        enable = true;
        swapPartSize = "8G";
      };
    };
    bundles = {
      x86-64-uefi-boot = enabled;
      base-minimal-nixos = enabled;
      gui-desktop-environment = enabled;
    };
    features = {
      laptop-device-settings = enabled;
      rdp-client-gnome = enabled;
    };
    programs = {
      #   plex.enable = true;
      nix-software-center = enabled;
      discord = enabled;
    };
  };
}

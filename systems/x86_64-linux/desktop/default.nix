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
    disko.zfs-only-ephemeral = {
      enable = true;
      encryption = false;
      blockDevice = "/dev/nvme0n1";
      swap = {
        enable = true;
        swapPartSize = "16G";
      };
    };

    bundles = {
      x86-64-uefi-boot = enabled;
      base-minimal-nixos = enabled;
      gui-desktop-environment = enabled;
      desktop-gaming = enabled;
    };
    features = {
      amd-gpu = enabled;
      yubikey-gui-functionality = enabled;
      embedded-dev-environment = enabled;
      rdp-client-gnome = enabled;
    };
    programs = {
      discord = enabled;
      docker = enabled;
      retroarch = enabled;
    };
  };
}

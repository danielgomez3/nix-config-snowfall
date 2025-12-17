# systems/x86_64-linux/server/default.nix
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
    # {config.facter.reportPath = ./facter.json;}
    # inputs.nixos-facter-modules.nixosModules.facter
    # {config.facter.reportPath = ./facter.json;}
  ];

  myVars.username = "daniel";
  myVars.hostname = "server";

  profiles.${namespace}.my.nixos = {
    disko.bios-uefi-gpt = {
      enable = true;
      blockDevice = "/dev/nvme0n1";
      swapPart = {
        enable = true;
        size = "16G";
      };
    };
    bundles = {
      x86-64-uefi-boot = enabled;
      base-minimal-nixos = enabled;
    };
    features = {
      # wireguard-client.enable = true; # Maybe add to base-system.nix
      # minecraft-server-docker.enable = true;
      # macos-emulation.enable = false;
    };
    programs = {
      # plex = enabled;
    };
  };
}

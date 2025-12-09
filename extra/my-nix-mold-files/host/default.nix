# WIP
{
  lib,
  pkgs,
  config,
  inputs,
  namespace,
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

  users.users.${"daniel"} = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  # profiles.${namespace} = {
  #   bitwarden.enable = true;
  #   programs.tailscale.enable = true;
  # };
  profiles.${namespace}.my.nixos = {
    bundles = {
      x86-64-uefi-boot.
      core-minimal-nixos.enable = true;
      gui-desktop-environment.enable = true;
    };
    # features = {
    # };
    # programs = {
    #   plex.enable = true;
    # };
  };
}

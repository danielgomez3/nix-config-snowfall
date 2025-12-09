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

  # profiles.${namespace} = {
  #   bitwarden.enable = true;
  #   programs.tailscale.enable = true;
  # };
  profiles.${namespace}.my.nixos = {
    bundles = {
      x86-64-uefi-boot = enabled;
      core-minimal-nixos = enabled;
      gui-desktop-environment = enabled;
    };
    features = {
    };
    # programs = {
    #   plex.enable = true;
    # };
  };
}

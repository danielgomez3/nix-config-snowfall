{
  lib,
  pkgs,
  config,
  inputs,
  namespace,
  ...
}: let
in {
  imports = [
    ./hardware-configuration.nix
    # inputs.nixos-facter-modules.nixosModules.facter
    # {config.facter.reportPath = ./facter.json;}
  ];

  myVars.username = "daniel";
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
      desktop-environment.enable = true;
    };
    # features = {
    # };
    # programs = {
    #   plex.enable = true;
    # };
  };

  system.stateVersion = "25.11";
}

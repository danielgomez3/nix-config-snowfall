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

  nixpkgs.config.allowUnfree = true;

  # profiles.${namespace} = {
  #   bitwarden.enable = true;
  #   programs.tailscale.enable = true;
  # };
  profiles.${namespace}.nixos = {
    # bundles = {
    # };
    # features = {
    # };
    programs = {
      bitwarden.enable = true;
    };
  };

  system.stateVersion = "25.11";
}

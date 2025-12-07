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

  profiles.${namespace} = {
    # systemd-boot.enable = true;
    bitwarden.enable = true;
  };

  system.stateVersion = "23.11";
}

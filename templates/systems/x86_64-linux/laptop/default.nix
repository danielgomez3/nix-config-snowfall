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

  system.stateVersion = "23.11"; # Did you read the comment?
}

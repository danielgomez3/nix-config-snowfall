# systems/x86_64-linux/usb/default.nix
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
    (import "${inputs.self.outPath}/disko/luks/disko-config.nix" {
      inherit config;
      block-device = "sda";
    })
    # ./hardware-configuration.nix
    # inputs.nixos-facter-modules.nixosModules.facter
    # {config.facter.reportPath = ./facter.json;}
  ];

  myVars.username = "daniel";
  myVars.hostname = "usb";

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
    };
    features = {
    };
    # programs = {
    #   plex.enable = true;
    # };
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = lib.mkForce true; # ← CHANGE TO TRUE
      KbdInteractiveAuthentication = lib.mkForce true; # ← CHANGE TO TRUE
    };
  };
}

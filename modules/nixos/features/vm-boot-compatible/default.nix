# vm-boot-compatible.nix
# NOTE
# This allows any host to be able to boot into a VM and login.
# Transfers age keys, etc.
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
  cfg = config.profiles.${namespace}.my.nixos.features.vm-boot-compatible;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.nixos.features.vm-boot-compatible = {
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'features', of module 'vm-boot-compatible', for namespace '${namespace}'.";
  };
  # imports = [./vm-with-nixosrebuild.nix];
  config = mkIf cfg.enable {
    fileSystems."/persistent/run" = {
      device = "secrets"; # This must match the key in sharedDirectories
      fsType = "9p";
      options = ["trans=virtio" "version=9p2000.L" "ro" "cache=loose"];
      neededForBoot = true;
    };

    virtualisation.vmVariant = {lib, ...}: {
      # HACK can't log in to system!
      users = {
        users.root = {
          hashedPasswordFile = lib.mkForce null;
          initialPassword = "123";
        };
        users.${config.myVars.username} = {
          hashedPasswordFile = lib.mkForce null;
          # hashedPassword = lib.mkForce null; # Clear any hashed password
          initialPassword = "123";
          # password = lib.mkForce null; # Also clear password if set
          # isNormalUser = true;
          # extraGroups = ["wheel"];
          # shell = pkgs.zsh;
          # ignoreShellProgramCheck = true;
        };
      };

      virtualisation.diskSize = 100000; # 100GB in MB
      virtualisation.memorySize = 8192; # 8GB
      virtualisation.cores = 8;
      virtualisation.graphics = false;
      disko.devices.disk.main.imageSize = "20G";

      # TODO: can't log in to system, maybe implement something like this:
      # virtualisation = {
      #   sharedDirectories = {
      #     secrets = {
      #       source = "/run";
      #       target = lib.mkForce "/persistent/run";
      #     };
      #   };
      # };
    };
  };
}

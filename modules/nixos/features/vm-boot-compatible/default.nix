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
    virtualisation.vmVariant = {
      virtualisation.diskSize = 100000; # 100GB in MB
      virtualisation.memorySize = 8192; # 8GB
      virtualisation.cores = 8;
      virtualisation.sharedDirectories = lib.mkForce {
        keys = {
          source = "/home/${config.myVars.username}/.config/sops/age";
          target = "/root/.config/sops/age";
        };
      };
      virtualisation.graphics = false;
      disko.devices.disk.main.imageSize = "20G";
    };
  };
}

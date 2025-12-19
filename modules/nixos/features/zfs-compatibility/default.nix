# modules/nixos/features/zfs-compatibility/default.nix
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
  cfg = config.profiles.${namespace}.my.nixos.features.zfs-compatibility;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt mkOpt;
in {
  options.profiles.${namespace}.my.nixos.features.zfs-compatibility = {
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'features', of module 'zfs-compatibility', for namespace '${namespace}'.";
    blockDevice =
      mkOpt lib.types.str "" "disk by id is prefered";
  };
  config = mkIf cfg.enable {
    # profiles.${namespace}.my.nixos = {
    # };
    # assertions = [{assertion = true; message = "";}];
    networking.hostId = cfg.zfs.hostID;
    environment.systemPackages = [pkgs.zfs-prune-snapshots];
    boot = {
      # Newest kernels might not be supported by ZFS
      kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
      kernelParams = [
        "nohibernate"
        "zfs.zfs_arc_max=17179869184"
      ];
      supportedFilesystems = ["vfat" "zfs"];
      zfs = {
        devNodes = cfg.blockDevice;
        forceImportAll = true;
        requestEncryptionCredentials = true;
      };
    };
    services.zfs = {
      autoScrub.enable = true;
      trim.enable = true;
    };
  };
}

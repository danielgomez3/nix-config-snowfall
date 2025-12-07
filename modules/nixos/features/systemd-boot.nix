{
  config,
  lib,
  system,
  inputs,
  namespace,
  pkgs,
  ...
}: let
  cfg = config.profiles.${namespace}.features.systemd-boot;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.features.systemd-boot = {
    enable = mkEnableOption "Enable systemd-boot";
  };

  config = mkIf cfg.enable {
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 3;
      timeout = lib.mkForce 8;
    };
  };
}

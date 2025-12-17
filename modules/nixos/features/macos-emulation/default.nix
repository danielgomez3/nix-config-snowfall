# modules/nixos/features/macos-emulation/default.nix
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
  cfg = config.profiles.${namespace}.my.nixos.features.macos-emulation;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.nixos.features.macos-emulation = {
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'features', of module 'macos-emulation', for namespace '${namespace}'.";
  };
  imports = [inputs.nixtheplanet.nixosModules.macos-ventura];
  config = mkIf cfg.enable {
    # profiles.${namespace}.my.nixos = {
    # };
    # assertions = [{assertion = true; message = "";}];

    services.macos-ventura = {
      enable = true;
      openFirewall = true;
      vncListenAddr = "0.0.0.0";
      vncDisplayNumber = 1;
    };
  };
}

# macos-emulation.nix
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
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.nixos.features.macos-emulation = {
    enable = mkEnableOption "Enable custom 'nixos', module 'macos-emulation', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    # profiles.${namespace}.my = {
    #   nixos = {
    #     bundles = {
    #     };
    #     features = {
    #     };
    #     programs = {
    #     };
    #   };
    #   home = {
    #     bundles = {
    #     };
    #     features = {
    #     };
    #     programs = {
    #     };
    #   };
    # };
    imports = [inputs.nixtheplanet.nixosModules.macos-ventura];
    services.macos-ventura = {
      enable = true;
      openFirewall = true;
      vncListenAddr = "0.0.0.0";
      vncDisplayNumber = 1;
    };
  };
}

# xxmodulexx.nix
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
  cfg = config.profiles.${namespace}.my.xxplatformxx.xxcategoryxx.xxmodulexx;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.xxplatformxx.xxcategoryxx.xxmodulexx = {
    enable = mkEnableOption "Enable custom 'xxplatformxx', module 'xxmodulexx', for namespace '${namespace}'.";
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

    imports = [
      inputs.nix-flatpak.nixosModules.nix-flatpak
      # inputs.nix-flatpak.homeManagerModules.nix-flatpak
      # inputs.flatpaks.homeManagerModules.nix-flatpak
    ];
    services.flatpak.enable = true;
    services.flatpak.packages = [
      {
        appId = "org.vinegarhq.Sober";
        origin = "flathub";
      }
    ];
  };
}

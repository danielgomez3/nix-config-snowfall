# kdeconnect.nix
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
  cfg = config.profiles.${namespace}.my.home.programs.kdeconnect;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.home.programs.kdeconnect = {
    enable = mkEnableOption "Enable custom 'home', module 'kdeconnect', for namespace '${namespace}'.";
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

    # home.packages = with pkgs; [
    #   kdePackages.kpeople # HACK: Get kde sms working properly
    #   kdePackages.kpeoplevcard # HACK: Get kde sms working properly
    # ];

    services.kdeconnect = {
      enable = true;
      indicator = false;
    };
  };
}

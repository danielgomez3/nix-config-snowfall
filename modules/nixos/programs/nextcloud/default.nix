# nextcloud.nix
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
  cfg = config.profiles.${namespace}.my.nixos.programs.nextcloud;
  inherit (lib) mkEnableOption mkIf;

  hostname = config.myVars.hostname;
in {
  options.profiles.${namespace}.my.nixos.programs.nextcloud = {
    enable = mkEnableOption "Enable custom 'nixos', module 'nextcloud', for namespace '${namespace}'.";
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
  };
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud32;
    hostName = hostname;
    config.adminpassFile = config.sops.secrets."nextcloud-secret-pass".path;
    config.dbtype = "sqlite";
  };

  services.nginx.virtualHosts."${hostname}".listen = [
    {
      addr = "0.0.0.0";
      port = 9090;
    }
  ];
}

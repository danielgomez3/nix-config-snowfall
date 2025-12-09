# wireguard-server.nix
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
  cfg = config.profiles.${namespace}.my.nixos.features.wireguard-server;
  inherit (lib) mkEnableOption mkIf;

  username = config.myVars.username;
  hostname = config.myVars.hostname;
  ports = config.myVars.ports;
in {
  options.profiles.${namespace}.my.nixos.features.wireguard-server = {
    enable = mkEnableOption "Enable custom 'nixos', module 'wireguard-server', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {

  networking.wireguard.interfaces.wg0 = {
    ips = ["10.100.0.1/24"];
    listenPort = 51820;
    privateKeyFile = config.sops.secrets."wireguard-private-key-file/${hostname}".path;
    peers = [
      {
        publicKey = "XAek67dqDTUuk94381DYI2bCHEdbC9l26tNH58FIUD8=";
        allowedIPs = ["10.100.0.2/32"];
        persistentKeepalive = 25;
      }
    ];
  };
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
}

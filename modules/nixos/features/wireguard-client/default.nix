# modules/nixos/features/wireguard-client/default.nix
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
  cfg = config.profiles.${namespace}.my.nixos.features.wireguard-client;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;

  username = config.myVars.username;
  hostname = config.myVars.hostname;
  ports = config.myVars.ports;
  ipMap = {
    "server" = "10.100.0.2";
    "laptop" = "10.100.0.3";
    "desktop" = "10.100.0.4";
    # Add more as needed
  };
  wgIP = ipMap.${hostname} or "10.100.0.100"; # fallback IP
in {
  options.profiles.${namespace}.my.nixos.features.wireguard-client = {
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'features', of module 'wireguard-client', for namespace '${namespace}'.";
  };

  config = mkIf cfg.enable {
    # profiles.${namespace}.my.nixos = {
    # };
    # assertions = [{assertion = true; message = "";}];

    networking.firewall = {
      allowedUDPPorts = [51820];
      allowedTCPPorts = [ports.mc 8787]; # Minecraft port
    };

    networking.wireguard.interfaces.wg0 = {
      ips = ["${wgIP}/24"];
      listenPort = 51820;
      privateKeyFile = config.sops.secrets."wireguard-private-key-file/${hostname}".path;

      peers = [
        {
          # VPS's public key
          publicKey = "qXKphez8ANTJVcYEdk8rAPc6ypif1WzNjNEm369YPQo="; # This can stay the same across all clients!
          allowedIPs = ["10.100.0.0/24"]; # ONLY route traffic meant for the VPS subnet through WireGuard.

          # Your VPS public IP and port
          endpoint = "danielgomezcoder.org:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}

# vaultwarden.nix
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
  cfg = config.profiles.${namespace}.my.nixos.programs.vaultwarden;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.nixos.programs.vaultwarden = {
    enable = mkEnableOption "Enable custom 'nixos', module 'vaultwarden', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {

  services.vaultwarden = {
    enable = true;
    environmentFile = config.sops.secrets.vaultwarden-env.path;
    config = {
      # Refer to https://github.com/dani-garcia/vaultwarden/blob/main/.env.template
      DOMAIN = "https://server.silverside-solfege.ts.net";
      SIGNUPS_ALLOWED = false;
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
      ROCKET_LOG = "critical";
    };
  };
  services.caddy = {
    enable = true;
    virtualHosts."server.silverside-solfege.ts.net".extraConfig = ''
      encode zstd gzip
      reverse_proxy :${toString config.services.vaultwarden.config.ROCKET_PORT} {
          header_up X-Real-IP {remote_host}
      }
    '';
  };
  # Allow the Caddy user(and service) to edit certs
  services.tailscale.permitCertUid = "caddy";
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

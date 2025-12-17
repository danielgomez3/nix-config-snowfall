# sops.nix
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
  cfg = config.profiles.${namespace}.my.nixos.programs.sops;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;

  secretspath = builtins.toString inputs.mysecrets;
  username = config.myVars.username;
  hostname = config.myVars.hostname;
in {
  options.profiles.${namespace}.my.nixos.programs.sops = {
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'programs', of module 'sops', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    environment.variables.GITHUB_TOKEN = config.sops.secrets.github_token.path;
    sops = {
      defaultSopsFile = "${secretspath}/secrets.yaml";
      defaultSopsFormat = "yaml";
      age.keyFile =
        if config.myVars.isEphemeral
        then "/persistent/root/.config/sops/age/keys.txt" # Ephemeral: use persistent location
        else "/root/.config/sops/age/keys.txt"; # Non-ephemeral: normal location
      # age.keyFile = "/root/.config/sops/age/keys.txt"; # Non-ephemeral: normal location
      templates = {
        "minecraft-cf-api-key".content = ''
          CF_API_KEY=${config.sops.placeholder."minecraft/CF_API_KEY"}
        '';
      };
      secrets = lib.mkMerge [
        {
          email = {};
          email_password = {
            # owner = "maddy";
            # group = "maddy";
            # mode = "0400"; # Read-only by maddy
          };
          user_password = {
            neededForUsers = true;
          };
          "luks_password" = {};
          "dkim/private_key" = {};
          # "yubikey" = {};
          "wifi_home.env" = {};
          "gmail_app_password" = {};
          "vaultwarden-env" = {
            # path = "/var/lib/vaultwarden/vaultwarden.env";
            # owner = "vaultwarden";
            # group = "vaultwarden";
            # mode = "0400"; # Read-only for vaultwarden user
          };
          "CLOUDFLARE_API_KEY" = {};
          "CLOUDFLARE_EMAIL" = {};
          "nextcloud-secret-pass" = {};
          "tailscale" = {};
          "borgbase/repo" = {};
          github_token = {
            owner = config.users.users.${username}.name;
            group = config.users.users.${username}.group;
          };
          "google_drive/id" = {};
          "google_drive/secret" = {};
          "google_drive/token" = {};
          "syncthing/gui_password" = {};
          "generic-pass" = {};
          "minecraft/CF_API_KEY" = {};
        }
        # # TODO: maybe put this in only syncthing.nix?
        # (lib.mkIf config.myNixOS.syncthing.enable {
        #   "syncthing/${hostname}/key_pem" = {
        #     owner = config.users.users.${username}.name;
        #     mode = "0700"; # Restrict read and write access to user only
        #   };
        #   "syncthing/${hostname}/cert_pem" = {
        #     owner = config.users.users.${username}.name;
        #     mode = "0700"; # Restrict read and write access to user only
        #   };
        # })

        # # TODO Maybe put this in wireguard.nix files?
        # # TODO OR condition for clients..
        # # (lib.mkIf config.myNixOS.wireguard-server.enable
        # #   or config.myNixOS.wireguard-client.enable {
        # #     "wireguard-private-key-file/${hostname}" = {
        # #       owner = config.users.users.${username}.name;
        # #       mode = "0700"; # Restrict read and write access to user only
        # #     };
        # #   })

        # TODO: add logic for server
        (lib.mkIf (config.profiles.internal.my.nixos.features.wireguard-client.enable) {
          "wireguard-private-key-file/${hostname}" = {
            owner = config.users.users.${username}.name;
            mode = "0700";
          };
        })
      ];
    };
  };
}

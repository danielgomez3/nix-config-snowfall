# modules/nixos/features/myNginxWebserver/default.nix
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
  cfg = config.profiles.${namespace}.my.nixos.features.myNginxWebserver;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.nixos.features.myNginxWebserver = {
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'features', of module 'myNginxWebserver', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    # profiles.${namespace}.my.nixos = {
    # };
    # assertions = [{assertion = true; message = "";}];

    services.nginx = {
      enable = true;
      # Explicitly set the user nginx should run as
      user = "nginx"; # This is the default in NixOS

      # NOTE: for testing. Like 'Hello, World'
      # virtualHosts.exampleVirtualHost = {
      #   listen = [
      #     {
      #       addr = "0.0.0.0";
      #       port = 8787;
      #     }
      #   ];
      #   locations."~.*" = {
      #     return = "200 '<html><body>It works</body></html>'";
      #     extraConfig = ''
      #       default_type text/html;
      #     '';
      #   };
      # };
      virtualHosts."downloads.danielgomezcoder.org" = {
        listen = [
          {
            addr = "0.0.0.0";
            port = 8787;
          }
        ];
        root = "/var/www";
        locations."/" = {
          index = "index.html index.htm";
          # Enable directory listing if no index file found
          extraConfig = ''
            autoindex on;
          '';
        };
        # NOTE: Just for testing purposes:
        # locations."~.*" = {
        #   return = "200 '<html><body>It works</body></html>'";
        #   extraConfig = ''
        #     default_type text/html;
        #   '';
        # };
      };
    };
    # NOTE deleteme?
    # NixOS already creates nginx user automatically
    # But let's ensure proper permissions
    # system.activationScripts.web-permissions = ''
    #   mkdir -p /var/www
    #   chown nginx:nginx /var/www
    #   chmod 755 /var/www
    # '';
  };
}

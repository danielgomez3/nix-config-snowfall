# printing.nix
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
  cfg = config.profiles.${namespace}.my.nixos.features.printing;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.nixos.features.printing = {
    enable = mkEnableOption "Enable custom 'nixos', module 'printing', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    profiles.${namespace}.my = {
      nixos = {
        bundles = {
        };
        features = {
        };
        programs = {
        };
      };
      #   home = {
      #     bundles = {
      #     };
      #     features = {
      #     };
      #     programs = {
      #     };
      #   };
    };

    # https://wiki.nixos.org/wiki/Printing
    services = {
      # Enable CUPS to print documents.
      printing = {
        enable = true;
        drivers = [pkgs.brlaser];
        listenAddresses = ["*:631"];
        allowFrom = ["all"];
        browsing = true;
        defaultShared = true;
        openFirewall = true;
      };
      # Enable autodescovery of network printers
      # avahi = {
      #   enable = true;
      #   nssmdns4 = true;
      #   openFirewall = true;
      # };
    };
    services = {
      # Enable CUPS to print documents.
      printing = {
        enable = true;
        drivers = [pkgs.brlaser];
        listenAddresses = ["*:631"];
        allowFrom = ["all"];
        browsing = true;
        defaultShared = true;
        openFirewall = true;
      };

      # Enable autodescovery of network printers
    };
  };
}

# modules/nixos/features/rdp-client-gnome/default.nix
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
  cfg = config.profiles.${namespace}.my.nixos.features.rdp-client-gnome;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.nixos.features.rdp-client-gnome = {
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'features', of module 'rdp-client-gnome', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    # Enable the GNOME RDP components
    services.gnome.gnome-remote-desktop.enable = true;

    # Ensure the service starts automatically at boot so the settings panel appears
    systemd.services.gnome-remote-desktop = {
      wantedBy = ["graphical.target"];
    };

    # Open the default RDP port (3389)
    networking.firewall.allowedTCPPorts = [3389];

    # Disable autologin to avoid session conflicts
    services.displayManager.autoLogin.enable = false;
    services.getty.autologinUser = null;
  };
}

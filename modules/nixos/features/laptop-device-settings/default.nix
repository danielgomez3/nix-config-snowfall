# laptop-device-settings.nix
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
  cfg = config.profiles.${namespace}.my.nixos.features.laptop-device-settings;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.nixos.features.laptop-device-settings = {
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'features', of module 'laptop-device-settings', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    # profiles.${namespace}.my.nixos = {
    # };
    # profiles.${namespace}.my.home = {
    # };
    services = {
      libinput.touchpad.disableWhileTyping = true;
      syncthing = {
        guiAddress = "127.0.0.1:8383";
      };
    };

    services.xserver = {
      xkb.options = "caps:swapescape";
    };
  };
}

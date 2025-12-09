# gui-apps.nix
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
  cfg = config.profiles.${namespace}.my.nixos.features.gui-apps;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.nixos.features.gui-apps = {
    enable = mkEnableOption "Enable custom 'nixos', module 'gui-apps', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    profiles.${namespace}.my.nixos = {
      programs = {
        firefox.enable = true;
      };
    };

    environment.systemPackages = with pkgs; [
      xorg.xauth # for X11 forwarding.
    ];

    home-manager.users.${config.myVars.username} = {
      myHomeManager = {
        zed.enable = true;
      };
      home.packages = with pkgs; [
        # Sway/Wayland/Hyprland
        grim
        slurp
        wl-clipboard
        xclip
        xorg.xrandr
        wlprop
        pw-volume
        brightnessctl
        swappy
        # gui apps
        #qutebrowser-qt5
        #google-chrome
        zoom-us
        slack
        spotify
        kdePackages.okular
        plexamp
        libreoffice
        hunspell
        hunspellDicts.uk_UA
        hunspellDicts.th_TH
        # xournalpp
        feh
        # ardour # failed build?
        audacity
        vlc
        evince
        # Misc.
        bluez
        bluez-alsa
        bluez-tools
        imagemagick
      ];
    };
  };
}

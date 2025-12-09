# gui-desktop-apps.nix
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
  cfg = config.profiles.${namespace}.my.home.features.gui-desktop-apps;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.home.features.gui-desktop-apps = {
    enable = mkBoolOpt false "Enable custom module for platform 'home', of category 'features', of module 'gui-desktop-apps', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    profiles.${namespace}.my.home = {
      programs = {
        wezterm = enabled;
        kitty = enabled;
        zathura = enabled;
        obs-studio = enabled;
        kdeconnect = enabled;
        mangohud = enabled;
        thunderbird = enabled;
      };
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
}

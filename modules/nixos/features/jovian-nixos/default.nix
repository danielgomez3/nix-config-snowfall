# modules/nixos/features/jovian-nixos/default.nix
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
  cfg = config.profiles.${namespace}.my.nixos.features.jovian-nixos;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  imports = [
    inputs.jovian.nixosModules.default
  ];
  options.profiles.${namespace}.my.nixos.features.jovian-nixos = {
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'features', of module 'jovian-nixos', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    # programs.gamescope = {
    #   enable = true;
    #   capSysNice = true;
    # };
    programs.steam.gamescopeSession = {
      enable = true;
    };

    services.displayManager.defaultSession = "gamescope-session";
    networking.networkmanager.enable = true;

    jovian.steam.enable = true;
    jovian.steam.autoStart = true;
    jovian.steam.desktopSession = "gamescope-wayland";

    jovian.decky-loader.enable = true;
    jovian.devices.steamdeck.enableControllerUdevRules = true;
    jovian.steam.user = "${config.myVars.username}";
    jovian.steamos.useSteamOSConfig = true;

    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
        extraPkgs = pkgs':
          with pkgs'; [
            xorg.libXcursor
            xorg.libXi
            xorg.libXinerama
            xorg.libXScrnSaver
            libpng
            libpulseaudio
            libvorbis
            stdenv.cc.cc.lib
            libkrb5
            keyutils
          ];
      };
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      extraCompatPackages = [pkgs.proton-ge-bin];
    };

    environment.systemPackages = with pkgs; [steam-tui];

    services.udev.packages = [pkgs.game-devices-udev-rules];
    hardware.uinput.enable = true;
  };
}

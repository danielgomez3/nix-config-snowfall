# voice-transcription-gnome.nix
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
  cfg = config.profiles.${namespace}.my.nixos.features.voice-transcription-gnome;
  inherit (lib) mkEnableOption mkIf;

  wsi = pkgs.callPackage "${inputs.self.outPath}/derivations/blurt-wsi" {};
  transcribe = pkgs.callPackage "${inputs.self.outPath}/derivations/blurt-transcribe" {};
in {
  options.profiles.${namespace}.my.nixos.features.voice-transcription-gnome = {
    enable = mkEnableOption "Enable custom 'nixos', module 'voice-transcription-gnome', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
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
    environment.systemPackages = with pkgs; [
      gnomeExtensions.blurt
      # deps:
      whisper-cpp # not necessary?
      transcribe
      sox
      xsel
      curl
    ];
    home-manager.users.${config.myVars.username} = {
      dconf.settings = {
        "org/gnome/shell" = {
          enabled-extensions = [
            pkgs.gnomeExtensions.blurt.extensionUuid
          ];
        };

        "org/gnome/shell/extensions/blurt" = {
          whisper-path = "${wsi}/bin/";
        };
      };
    };
  };
}

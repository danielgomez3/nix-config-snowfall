# ollama.nix
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
  cfg = config.profiles.${namespace}.my.nixos.programs.ollama;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.nixos.programs.ollama = {
    enable = mkEnableOption "Enable custom 'nixos', module 'ollama', for namespace '${namespace}'.";
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

    environment.systemPackages = [pkgs.chatbox];

    services.open-webui = {
      # Default is localhost:8080
      enable = true;
    };
    services.ollama = {
      enable = true;
      loadModels = ["deepseek-r1:70b"];
    };
  };
}

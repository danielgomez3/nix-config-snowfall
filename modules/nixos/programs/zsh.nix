# xxmodulenamexx.nix
{
  config,
  lib,
  system,
  inputs,
  namespace,
  pkgs,
  ...
}: let
  cfg = config.profiles.${namespace}.nixos.programs.zsh;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.nixos.programs.zsh = {
    enable = mkEnableOption "Enable custom 'nixos' module 'zsh' for namespace '${namespace}'";
  };
  config =
    mkIf cfg.enable {
    };
}

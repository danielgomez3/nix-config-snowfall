# modules/nixos/programs/discord/default.nix
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
  cfg = config.profiles.${namespace}.my.nixos.programs.discord;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.nixos.programs.discord = {
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'programs', of module 'discord', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    users.users.${config.myVars.username}.packages = with pkgs; [
      legcord
    ];
  };
}

# modules/nixos/programs/roblox/default.nix
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
  cfg = config.profiles.${namespace}.my.nixos.programs.roblox;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.nixos.programs.roblox = {
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'programs', of module 'roblox', for namespace '${namespace}'.";
  };
  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];
  config = mkIf cfg.enable {
    # profiles.${namespace}.my.nixos = {
    # };
    # profiles.${namespace}.my.home = {
    # };
    assertions = [
      {
        assertion = config.profiles.${namespace}.my.nixos.programs.flatpak.enable;
        message = "Please make sure to enable flatpak for declarative flatpak managment!";
      }
    ];
    services.flatpak.packages = [
      {
        appId = "org.vinegarhq.Sober";
        origin = "flathub";
      }
    ];
  };
}

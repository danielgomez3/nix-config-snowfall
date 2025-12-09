# user-config.nix
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
  cfg = config.profiles.${namespace}.my.nixos.features.user-config;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.nixos.features.user-config = {
    enable = mkEnableOption "Enable custom 'nixos', module 'user-config', for namespace '${namespace}'.";
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
    users = {
      # Define a user account. Don't forget to set a password with 'passwd'.
      mutableUsers = false; # Required for a password 'passwd' to be set via sops during system activation (over anything done imperatively)!
      users.root.initialHashedPassword = lib.mkForce null; # force it and override ISO installer module
      users.root.hashedPasswordFile = config.sops.secrets.user_password.path;
      users.${config.myVars.username} = {
        hashedPasswordFile = config.sops.secrets.user_password.path;
        isNormalUser = true;
        extraGroups = ["wheel"];
        shell = pkgs.zsh;
        ignoreShellProgramCheck = true;
      };
    };
  };
}

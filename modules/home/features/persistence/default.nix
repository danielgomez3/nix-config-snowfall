# modules/home/features/persistence/default.nix
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
  cfg = config.profiles.${namespace}.my.home.features.persistence;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.home.features.persistence = {
    enable = mkBoolOpt false "Enable custom module for platform 'home', of category 'features', of module 'persistence', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    home.persistence."/home/${config.snowfallorg.user.name}" = {
      directories = [
        ".steam"
        ".local/share/Steam"
        ".cache/Steam"
      ];
      files = [
        ".steam/steamid"
        ".steam/registry.vdf"
      ];
      allowOther = true;
    };

    # # Option 2: Using systemd tmpfiles (simpler)
    # systemd.tmpfiles.rules = [
    #   "L+ /home/your-username/.steam - - - - ${config.users.users.your-username.home}/.steam"
    # ];
  };
}

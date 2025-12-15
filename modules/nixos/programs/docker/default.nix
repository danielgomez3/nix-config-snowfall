# modules/nixos/programs/docker/default.nix
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
  cfg = config.profiles.${namespace}.my.nixos.programs.docker;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.nixos.programs.docker = {
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'programs', of module 'docker', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.docker-compose];

    # # NOTE: Rootless Docker:
    # # This is buggy! Docker isn't really meant to run rootless.. Try podman?
    virtualisation.docker = {
      #   # Consider disabling the system wide Docker daemon
      enable = true;

      #   rootless = {
      #     enable = true;
      #     setSocketVariable = true;
      #     # Optionally customize rootless Docker daemon settings
      #     daemon.settings = {
      #       dns = ["1.1.1.1" "8.8.8.8"];
      #       registry-mirrors = ["https://mirror.gcr.io"];
      #     };
      #   };
    };
    # If true, systemd user units will start at boot, rather than starting at login and stopping at logout
    users.users.${config.myVars.username}.linger = true;

    # Disable this if rootless docker
    # users.users.<username>.extraGroups = [ "docker" ];
  };
}

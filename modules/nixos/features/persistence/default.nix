# modules/nixos/features/persistence/default.nix
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
  cfg = config.profiles.${namespace}.my.nixos.features.persistence;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  # imports = [
  #   inputs.impermanence.nixosModules.impermanence
  #   inputs.persist-retro.nixosModules.persist-retro
  # ];
  options.profiles.${namespace}.my.nixos.features.persistence = {
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'features', of module 'persistence', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    # # Configure system-wide persistence
    # fileSystems."/persist".neededForBoot = true;
    # environment.persistence."/persist" = {
    #   hideMounts = true;
    #   # System directories that should survive reboots
    #   directories = [
    #     "/var/log"
    #     "/var/lib/nixos"
    #     "/var/lib/bluetooth"
    #     "/var/lib/systemd/coredump"
    #   ];
    #   # User daniel's home directory persistence
    #   users.daniel = {
    #     directories = [
    #       # Steam directories
    #       ".steam"
    #       ".local/share/Steam"
    #       ".cache/Steam"

    #       # Optional: Other directories you want to persist
    #       "Downloads"
    #       "Documents"
    #       "Pictures"
    #       ".ssh"
    #       ".gnupg"
    #       ".config"
    #       ".local/share/keyrings"
    #       ".local/share/direnv"
    #       ".nixops"
    #     ];
    #     # files = [
    #     #   # Steam files
    #     #   ".steam/steamid"
    #     #   ".steam/registry.vdf"

    #     #   # Optional: Other important files
    #     #   ".screenrc"
    #     #   ".bash_history"
    #     #   ".zsh_history"
    #     # ];
    #   };
    # };
  };
}

# transitory.nix
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
  cfg = config.profiles.${namespace}.my.home.features.transitory;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.home.features.transitory = {
    enable = mkEnableOption "Enable custom 'home', module 'transitory', for namespace '${namespace}'.";
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

    imports = [
      inputs.impermanence.homeManagerModules.impermanence
    ];
    home.persistence."/persistent/home/talyz" = {
      directories = [
        "/var/lib/NetworkManager" # Network connections
        "/etc/ssh" # SSH host keys if you enable SSH
        # Use bindfs for directories where applications expect real directories
        ".config"
        ".local/share"
        {
          directory = ".ssh";
          method = "bindfs";
        } # Explicit, but same as default
        # Use symlink for performance-critical or large directories
        {
          directory = ".local/share/Steam";
          method = "symlink"; # Better for large game files
        }
        # {
        #   directory = ".cache";
        #   method = "symlink"; # Cache doesn't need bindfs overhead
        # }

        # Use bindfs for security-sensitive directories
        # {
        #   directory = ".gnupg";
        #   method = "bindfs"; # GnuPG expects proper directory permissions
        # }
      ];
      files = [
        ".screenrc"
      ];
      allowOther = true;
    };
  };
}

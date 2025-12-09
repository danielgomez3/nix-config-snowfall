# x86_64-linux/daniel/default.nix
# NOTE: all nix machines with username 'daniel' will inherit this.
{
  lib,
  pkgs,
  namespace,
  ...
}: {
  snowfallorg.user = {
    enable = true;
    name = "daniel";
  };

  profiles.${namespace}.my.home = {
    bundles = {
    };
    # features = {
    # };
    programs = {
      zsh.enable = true;
      # helix.enable = true;
    };
  };

  home.stateVersion = "21.05";
}

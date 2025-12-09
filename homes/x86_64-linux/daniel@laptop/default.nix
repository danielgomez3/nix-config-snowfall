# x86_64-linux/daniel/default.nix
# NOTE: all nix machines with username 'daniel' will inherit this.
{
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib.${namespace}) enabled;
in {
  snowfallorg.user = {
    enable = true;
    name = "daniel";
  };

  profiles.${namespace}.my.home = {
    bundles = {
      core-minimal-home.enable = true;
    };
    features = {
      # gui-desktop-environment = false; # For non-nix machines only!
      gui-desktop-apps = enabled;
    };
    programs = {
    };
  };
}

# x86_64-linux/daniel/default.nix
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
      base-minimal-home = enabled;
    };
    features = {
    };
    programs = {
    };
  };
}

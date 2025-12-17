# x86_64-raw/daniel/default.nix
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

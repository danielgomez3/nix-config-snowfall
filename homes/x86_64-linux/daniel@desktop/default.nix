# __platform__/__username__/default.nix
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
    name = "__username__";
  };

  profiles.${namespace}.my.home = {
    bundles = {
      core-minimal-home = enabled;
    };
    features = {
    };
    programs = {
    };
  };
}

# xxplatformxx/xxusernamexx/default.nix
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
    name = "xxusernamexx";
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

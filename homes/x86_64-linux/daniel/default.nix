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

  profiles.${namespace}.home = {
    # bundles = {
    # };
    # features = {
    # };
    programs = {
      zsh.enable = true;
    };
  };

  home.stateVersion = "21.05";
}

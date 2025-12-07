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

  profiles.${namespace} = {
    cli.spicetify.enable = true;
    features.systemd-boot.enable = true;
  };

  home.stateVersion = "21.05";
}

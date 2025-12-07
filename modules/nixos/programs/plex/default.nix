{
  lib,
  config,
  namespace,
  ...
}:
with lib; {
  options.${namespace}.programs.plex.enable = mkEnableOption "plex";

  config = mkIf config.${namespace}.programs.plex.enable {
    nixpkgs.config.allowUnfree = true;
    services.plex = {
      enable = true;
      openFirewall = true;
      # user = "philip";
    };
  };
}

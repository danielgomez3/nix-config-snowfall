{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  cfg = config.profiles.${namespace}.nixos.programs.bitwarden;
  inherit
    (lib)
    mkEnableOption
    mkIf
    ;
in {
  options.profiles.${namespace}.nixos.programs.bitwarden = {
    enable = mkEnableOption "Bitwarden password manager";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (rbw.override {withFzf = true;})
      pinentry-curses
    ];
  };
}

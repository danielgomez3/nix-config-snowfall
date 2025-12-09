# pay-respects.nix
{
  lib,
  pkgs,
  inputs,
  namespace,
  system,
  target,
  format,
  virtual,
  systems,
  config,
  ...
}: let
  cfg = config.profiles.${namespace}.my.home.programs.pay-respects;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.home.programs.pay-respects = {
    enable = mkEnableOption "Enable custom 'home', module 'pay-respects', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {

  # home.packages = with pkgsUnstable; [
  #    pay-respects
  # ];
  # programs.zsh.initExtra = ''
  #     eval "$(${pkgsUnstable.pay-respects}/bin/pay-respects zsh --alias)"
  #   '';
  # programs.zsh.shellAliases = {
  #   f= ''
  #     'eval $(_PR_LAST_COMMAND="$(fc -ln -1)" _PR_ALIAS="$(alias)" _PR_SHELL="zsh" "pay-respects")'
  #     '';
  # };
  programs.pay-respects = {
    enable = false;
    # package = pkgsUnstable.pay-respects;
    enableZshIntegration = true;
    options = [
      "--alias"
      "f"
    ];
  };
    # profiles.${namespace}.my.home = {
    #   bundles = {
    #   };
    #   features = {
    #   };
    #   programs = {
    #   };
    # };
    # profiles.${namespace}.my.nixos = {
    #   bundles = {
    #   };
    #   features = {
    #   };
    #   programs = {
    #   };
    # };
  };
}

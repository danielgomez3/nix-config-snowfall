# xxmodulexx.nix
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
  cfg = config.profiles.${namespace}.my.xxplatformxx.xxcategoryxx.xxmodulexx;
  inherit (lib) mkEnableOption mkIf;
in {
  options.profiles.${namespace}.my.xxplatformxx.xxcategoryxx.xxmodulexx = {
    enable = mkEnableOption "Enable custom 'xxplatformxx', module 'xxmodulexx', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    # profiles.${namespace}.my = {
    #   nixos = {
    #     bundles = {
    #     };
    #     features = {
    #     };
    #     programs = {
    #     };
    #   };
    #   home = {
    #     bundles = {
    #     };
    #     features = {
    #     };
    #     programs = {
    #     };
    #   };
    # };
    ## NOTE: For Qemu
    systemd.tmpfiles.rules = ["L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware"];
    environment.systemPackages = with pkgs; [
      inputs.quickemu.packages.${system}.default
    ];

    ## NOTE: For Virtualbox
    users.extraGroups.vboxusers.members = ["${config.myVars.username}"];
    virtualisation.virtualbox.host.enable = true;
    virtualisation.virtualbox.host.enableExtensionPack = true;
    virtualisation.virtualbox.guest.enable = true;
    virtualisation.virtualbox.guest.dragAndDrop = true;
  };
}

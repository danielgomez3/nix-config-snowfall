# openssh.nix
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
  cfg = config.profiles.${namespace}.my.nixos.programs.openssh;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.nixos.programs.openssh = {
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'programs', of module 'openssh', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    users.users.${config.myVars.username} = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII8SFBz7G2gfy1uJ3PMcHQDwpKTPVJKHSMOge9GVEXHj daniel@server"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ1NjQTc2heiempOFsy6nTHbQj3lHyHqi1wUgc+hIrZe daniel@nas-server" # backup machine in case locked out of server
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOZCUX30GSq/IMWh+0/WUXp2Cq4DrUX+8b9oeAlfZnQX daniel@laptop"
      ];
    };

    users.users.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII8SFBz7G2gfy1uJ3PMcHQDwpKTPVJKHSMOge9GVEXHj daniel@server"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ1NjQTc2heiempOFsy6nTHbQj3lHyHqi1wUgc+hIrZe daniel@nas-server" # backup machine in case locked out of server
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOZCUX30GSq/IMWh+0/WUXp2Cq4DrUX+8b9oeAlfZnQX daniel@laptop"
    ];

    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
  };
}

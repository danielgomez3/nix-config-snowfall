# modules/nixos/features/netboot-server/default.nix
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
  cfg = config.profiles.${namespace}.my.nixos.features.netboot-server;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;

  pubKeys = config.users.users.${config.myVars.username}.openssh.authorizedKeys.keys;
  sys = lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ({
        config,
        pkgs,
        lib,
        modulesPath,
        ...
      }: {
        imports = [(modulesPath + "/installer/netboot/netboot-minimal.nix")];
        config = {
          services.openssh = {
            enable = true;
            openFirewall = true;

            settings = {
              PasswordAuthentication = false;
              KbdInteractiveAuthentication = false;
            };
          };

          users.users.root.openssh.authorizedKeys.keys = pubKeys;
        };
      })
    ];
  };
  build = sys.config.system.build;
in {
  options.profiles.${namespace}.my.nixos.features.netboot-server = {
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'features', of module 'netboot-server', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    # profiles.${namespace}.my.nixos = {
    # };
    # assertions = [{assertion = true; message = "";}];
    services.pixiecore = {
      enable = true;
      openFirewall = true;
      dhcpNoBind = true; # Use existing DHCP server.

      mode = "boot";
      kernel = "${build.kernel}/bzImage";
      initrd = "${build.netbootRamdisk}/initrd";
      cmdLine = "init=${build.toplevel}/init loglevel=4";
      debug = true;
    };

    # If you want to build a custom netboot image:
    # system.build.customNetboot = pkgs.writeScriptBin "make-netboot" ''
    #   #!/bin/sh
    #   nix-build '<nixpkgs/nixos>' \
    #     -I nixos-config=/etc/nixos/configuration.nix \
    #     -A config.system.build.netbootRamdisk \
    #     -o /tmp/netboot-initrd
    #   echo "Netboot image at: /tmp/netboot-initrd"
    # '';
  };
}

# modules/nixos/features/remote-unlock/default.nix
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
  cfg = config.profiles.${namespace}.my.nixos.features.remote-unlock;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;
in {
  options.profiles.${namespace}.my.nixos.features.remote-unlock = {
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'features', of module 'remote-unlock', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    # profiles.${namespace}.my.nixos = {
    # };
    # assertions = [{assertion = true; message = "";}];
    # services.openssh.hostKeys = [
    #   {
    #     bits = 4096;
    #     path = "/etc/ssh/ssh_host_rsa_key";
    #     type = "rsa";
    #   }
    #   {
    #     path = "/etc/ssh/ssh_host_ed25519_key";
    #     type = "ed25519";
    #   }
    # ];
    # HACK: when using nixos-anywhere, it's expecting ssh-host-keys, but those aren't generated yet because the system hasn't been booted! initrd can't find them, so this causes nixos-anywhere to fail. However, we can create it ourselves with this script. This doesn't clear the warnings nixos-anywhere warnings, but will work:
    # system.activationScripts.ssh-initrd-host-keys = ''
    #   if [ ! -f /etc/ssh/ssh_host_ed25519_key ]; then
    #     mkdir -p /etc/ssh
    #     ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""
    #   fi
    #   if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
    #     mkdir -p /etc/ssh
    #     ${pkgs.openssh}/bin/ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key -N ""
    #   fi
    # '';
    # boot.initrd.network = {
    #   # This will use udhcp to get an ip address.
    #   # Make sure you have added the kernel module for your network driver to `boot.initrd.availableKernelModules`,
    #   # so your initrd can load it!
    #   # Static ip addresses might be configured using the ip argument in kernel command line:
    #   # https://www.kernel.org/doc/Documentation/filesystems/nfs/nfsroot.txt
    #   enable = true;
    #   ssh = {
    #     enable = true;
    #     # To prevent ssh clients from freaking out because a different host key is used,
    #     # a different port for ssh is useful (assuming the same host has also a regular sshd running)
    #     port = 2222;
    #     # hostKeys paths must be unquoted strings, otherwise you'll run into issues with boot.initrd.secrets
    #     # the keys are copied to initrd from the path specified; multiple keys can be set
    #     # you can generate any number of host keys using
    #     # `ssh-keygen -t ed25519 -N "" -f /path/to/ssh_host_ed25519_key`
    #     # NOTE: this doesn't work on nixos-anywhere deployment without the HACK, see HACK for details.
    #     hostKeys = [
    #       /etc/ssh/ssh_host_ed25519_key
    #       /etc/ssh/ssh_host_rsa_key
    #     ];
    #     # public ssh key used for login
    #     authorizedKeys = config.users.users.${config.myVars.username}.openssh.authorizedKeys.keys;
    #   };
    # };
  };
}

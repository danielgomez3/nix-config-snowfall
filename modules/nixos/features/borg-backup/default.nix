# modules/nixos/features/borg-backup/default.nix
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
  cfg = config.profiles.${namespace}.my.nixos.features.borg-backup;

  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled mkBoolOpt;

  # Inspiration from  https://github.com/jnsgruk/nixos-config/blob/263eb07e8de01047aa1faa63f0fc2322e855cf9e/host/common/services/backup/default.nix#L32
  username = config.myVars.username;
  hostname = config.myVars.hostname;
  borgExcludes = [
    "/nix"
    "/tmp"
    "/usr"
    "*.log"
    "*.db"
    "*.sqlite"
    "*.cache"
    "*/.cache/*"
    "*/node_modules/*"
    "*.tmp"
    "*.qcow2"
    "*.vdi"
    "*.iso"
  ];
in {
  options.profiles.${namespace}.my.nixos.features.borg-backup = {
    enable = mkBoolOpt false "Enable custom module for platform 'nixos', of category 'features', of module 'borg-backup', for namespace '${namespace}'.";
  };
  config = mkIf cfg.enable {
    # profiles.${namespace}.my.nixos = {
    # };
    # assertions = [{assertion = true; message = "";}];

    # NOTE: Kind of naive. This line means whatever device has this module enabled (assuming server only here), will search for their key in the remote secrets.yaml. So the key would be private_ssh_keys: server_root
    sops.secrets."private_ssh_keys/${hostname}_root" = {};
    # NOTE:
    # to check on it, systemctl status borgbackup-job-borgbase.service
    # Also, root is the one that needs to give its key to manage borgbackup.
    services.borgbackup.jobs."borgbase" = {
      paths = [
        "/home/${username}/Documents"
      ];
      exclude = borgExcludes;
      # NOTE: Stable, was working:
      # environment.BORG_RSH = "ssh -i /root/.ssh/id_ed25519";
      environment.BORG = "ssh -i ${config.sops.secrets."private_ssh_keys/${hostname}_root".path}";
      repo = "ssh://q4mtob1t@q4mtob1t.repo.borgbase.com/./repo";
      compression = "auto,zstd";
      startAt = "daily";
      persistentTimer = true;
      encryption = {
        mode = "none";
      };
    };
  };
}

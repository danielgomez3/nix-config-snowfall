{config, ...}: {
  services.tailscale = {
    enable = true;
    # authKeyFile = config.sops.secrets.tailscale.path;
    extraUpFlags = [
      "--ssh"
    ];
  };
}

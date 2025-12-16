{
  config,
  lib,
  namespace,
  ...
}: {
  profiles.${namespace}.my.nixos = {
    features.persistence.enable = lib.mkForce false;
  };

  virtualisation.vmVariant = {
    virtualisation.diskSize = 100000; # 100GB in MB
    virtualisation.memorySize = 8192; # 8GB
    virtualisation.cores = 8;
    virtualisation.sharedDirectories = lib.mkForce {
      keys = {
        source = "/home/${config.myVars.username}/.config/sops/age";
        target = "/root/.config/sops/age";
      };
    };
    virtualisation.graphics = false;
    disko.devices.disk.main.imageSize = "20G";
  };
}

{config, ...}: {
  virtualisation.diskSize = 100000; # 100GB in MB
  virtualisation.memorySize = 8192; # 8GB
  virtualisation.cores = 8;
  virtualisation.sharedDirectories = {
    keys = {
      source = "/home/${config.myVars.username}/.config/sops/age";
      target = "/root/.config/sops/age";
    };
  };
}

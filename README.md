# TODO

- 'just' is currently in system env., we need to make the  development shell keep starship and all packages and themes etc., but add 'just', so we can remove 'just' from every system's 'base.nix' config file.
- Make shell sourced by direnv
- enable programs.ssh.forwardX11 to have clipboard on headless server connect to desktop envs.

# Documentation

## Using my template

<!-- TODO -->

```nix
nix flake init -t github:<>/templates#genericUser
```

## Module Layout

 Program configuration (like .dotfiles)
options.${namespace}.programs.headscale.enable = true;
options.${namespace}.features.client-side-net.enable = true;
options.${namespace}.bundles.desktop-environment.enable = true;

 Home-manager programs
options.${namespace}.home.programs.tailscale.enable = true;
options.${namespace}.home.features.3d-printer-device.enable = true;
options.${namespace}.home.bundles.desktop-environment.enable = true;


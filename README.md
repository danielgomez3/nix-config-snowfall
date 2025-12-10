# TODO

- change zsh prompt to always say host
- fix btop to work with any graphics card
- factor jovian so boot is inheriting from my modules
- create justfile recipe that will 'cat' all the related files in a system
- wrap emacs to run in the cloud with 'emacs --daemon'
- Look at jakehamilton and how he wrapsObs with overlay
- ability to ssh into vms
- make gnome use xorg, wayland buggin
- ⭐ make disko a module under modules to enable conditionally???
- create 'program' top level arg so you can dynamically ref the name in  the module desc
- create a justfile recipe that will rename a module to whatever, then put it into the correct dir with the correct naming convention, leaving contents undisturbed
- incorporate autoimpoprts to your library under 'lib' or however snowfall does it. This code specifically, than use it in your default.nix ubiquitously:
```nix
{lib, ...}: let
  inherit (builtins) filter map toString;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (lib.strings) hasSuffix;
in {
  imports = filter (hasSuffix ".nix") (
    map toString (filter (p: p != ./default.nix) (listFilesRecursive ./.))
  );
}

```
- add 'myvars'
- implement justfile submodules
- 'just' is currently in system env., we need to make the  development shell keep starship and all packages and themes etc., but add 'just', so we can remove 'just' from every system's 'base.nix' config file.
- Make shell sourced by direnv
- enable programs.ssh.forwardX11 to have clipboard on headless server connect to desktop envs.
- make a valid darwin config

# Documentation

## Using my template

<!-- TODO -->

```nix
nix flake init -t github:<>/templates#genericUser
```

## Supported systems:

Architecture	Nix System String	Common Use

x86_64 Linux     	x86_64-linux    	Standard Intel/AMD PCs, servers
aarch64 Linux     	aarch64-linux    	Raspberry Pi 4, AWS Graviton, ARM servers
x86_64 Darwin     	x86_64-darwin    	Intel Macs
aarch64 Darwin     	aarch64-darwin    	Apple Silicon Macs (M1/M2/M3)
i686 Linux     	i686-linux    	32-bit x86 (legacy)
ARMv6l Linux     	armv6l-linux    	Raspberry Pi Zero/1
ARMv7l Linux     	armv7l-linux    	Raspberry Pi 2/3, older ARM devices
riscv64 Linux     	riscv64-linux    	RISC-V development boards
x86_64 Windows     	x86_64-windows    	Windows via WSL2 or cross-compilation


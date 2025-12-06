# flake.nix
{
  inputs = {
    # Nix flake development/structure. Core inputs.
    # home-manager.url = "github:nix-community/home-manager"; # hm-stable
    # home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    mysecrets.url = "git+ssh://git@github.com/danielgomez3/nix-secrets.git?ref=main&shallow=1";
    mysecrets.flake = false;
    snowfall-lib.url = "github:snowfallorg/lib";
    snowfall-lib.inputs.nixpkgs.follows = "nixpkgs";
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    impermanence.url = "github:nix-community/impermanence"; # make custom iso data impermanent

    # Nix flake systems
    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs"; # Add this to your flake inputs
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    nix-on-droid.url = "github:nix-community/nix-on-droid/release-24.05";
    nix-on-droid.inputs.nixpkgs.follows = "nixpkgs";
    jovian.url = "github:Jovian-Experiments/Jovian-NixOS";
    jovian.inputs.nixpkgs.follows = "nixpkgs";

    # Nix flake deployment
    deploy-rs.url = "github:serokell/deploy-rs";
    nix-netboot-serve.url = "github:determinatesystems/nix-netboot-serve";

    # Nix flake tools
    wrapper-manager.url = "github:viperML/wrapper-manager";
    stylix.url = "github:nix-community/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR"; # Haven't used yet
    # nvf.url = "github:notashelf/nvf";
    # nvf.inputs.nixpkgs.follows = "nixpkgs";

    # Virtualization
    nixpkgs-kexec.url = "github:NixOS/nixpkgs/b81d4ded7076a39af7edfb1b50f024ef5fbb8b3f";
    nixtheplanet.url = "github:matthewcroughan/nixtheplanet";
    quickemu.url = "https://flakehub.com/f/quickemu-project/quickemu/4.9.7";
    nixos-generators.url = "github:nix-community/nixos-generators"; # create custom kexec tarballs, etc.
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs"; # create custom kexec tarballs, etc.
    nixos-images.url = "github:nix-community/nixos-images/"; # get a kexec tarball to use

    # Programs/Software
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    nixcraft.url = "github:loystonpais/nixcraft";
    nixcraft.inputs.nixpkgs.follows = "nixpkgs"; # Set correct nixpkgs name
    jambi.url = "github:guttermonk/jambi";
    nix-software-center.url = "github:snowfallorg/nix-software-center";
    # cosmic-manager.inputs.home-manager.follows = "home-manager";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;

      src = ./.;

      snowfall = {
        namespace = "daniel-namespace";
        meta = {
          name = "my-awesome-flake";
          title = "My Awesome Flake";
        };
      };

      deploy.nodes.test = {
        hostname = "test";
        interactiveSudo = true;
        profiles.system = {
          user = "root";
          path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos inputs.self.nixosConfigurations.test;
        };
      };

      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks inputs.self.deploy) inputs.deploy-rs.lib;

      devShells.x86_64-linux.default = let
        pkgs = import inputs.nixpkgs {system = "x86_64-linux";};
      in
        pkgs.mkShell {
          packages = [
            inputs.deploy-rs.packages.${pkgs.system}.deploy-rs
          ];
          shellHook = ''alias d="deploy"'';
        };
    };
}

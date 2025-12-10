# flake.nix
{
  description = "Daniel's Nix Flake ⛰️";
  nixConfig = {
    extra-experimental-features = ["nix-command" "flakes" "pipe-operators" "nix-command"];
  };
  inputs = {
    # Nix flake development/structure. Core inputs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager"; # hm-stable
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
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
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
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
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
  };

  outputs = inputs: let
    lib = inputs.snowfall-lib.mkLib {
      inherit inputs;
      src = ./.;
      # # You can optionally place your Snowfall-related files in another
      # # directory.
      # snowfall.root = ./nix;
    };
  in
    lib.mkFlake {
      # The attribute set specified here will be passed directly to NixPkgs when
      # instantiating the package set.
      channels-config = {
        # Allow unfree packages.
        allowUnfree = true;

        # Allow certain insecure packages
        permittedInsecurePackages = [
          # "firefox-100.0.0"
        ];

        # Additional configuration for specific packages.
        config = {
          # For example, enable smartcard support in Firefox.
          firefox.smartcardSupport = true;
        };
      };

      # # Add modules to all homes.
      homes.modules = with inputs; [
        # my-input.homeModules.my-module
        spicetify-nix.homeManagerModules.default
        impermanence.homeManagerModules.impermanence
      ];

      # # Add modules to a specific home.
      # homes.users."daniel@my-host".modules = with inputs; [
      #   # my-input.homeModules.my-module
      # ];

      # # Add modules to a specific home.
      # homes.users."my-user@my-host".specialArgs = {
      #   my-custom-value = "my-value";
      # };

      # # Add modules to a specific system.
      # systems.hosts.my-host = with inputs; [
      #   # my-input.nixosModules.my-module
      # ];

      systems.hosts = {
        laptop = {
        };
      };

      # # Add overlays for the `nixpkgs` channel.
      # overlays = with inputs; [
      #   # my-inputs.overlays.my-overlay
      # ];

      # # Add a custom value to `specialArgs`.
      # systems.hosts.laptop.specialArgs = {
      #   username = "daniel";
      # };

      # Add modules to all NixOS systems.
      systems.modules.nixos = with inputs; [
        inputs.sops-nix.nixosModules.sops
        inputs.disko.nixosModules.disko
        inputs.stylix.nixosModules.stylix
        inputs.nixos-facter-modules.nixosModules.facter
      ];

      # specialArgs = {
      #   username = "daniel";
      # };

      # # Add modules to all Darwin systems.
      systems.modules.darwin = with inputs; [
        nix-darwin.darwinModules.home-manager
        nix-homebrew.darwinModules.nix-homebrew
      ];

      snowfall = {
        # root = ./nix # Tell Snowfall Lib to look in the `./nix/` directory for  Nix files.
        namespace = "mountain"; # Choose a namespace to use for your flake's packages, library, and overlays.

        meta = {
          name = "daniel-flake"; # A slug to use in documentation when displaying things like file paths.
          title = "My mind is a mountain"; # A title to show for your flake, typically the name.
          extra_patterns = ["*.nix"];
          exclude_patterns = ["default.nix"];
        };
      };

      templates = {
        my-template = {
          description = "This is my template created with Snowfall Lib!";
          path = ./templates/my-template;
        };
      };

      # checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks inputs.self.deploy) inputs.deploy-rs.lib;

      devShells.x86_64-linux.default = let
        pkgs = import inputs.nixpkgs {system = "x86_64-linux";};
      in
        pkgs.mkShell {
          packages = [
            inputs.deploy-rs.packages.${pkgs.system}.deploy-rs
          ];
          shellHook = ''alias d="deploy"'';
        };

      deploy = lib.mkDeploy {inherit (inputs) self;};
    };
}

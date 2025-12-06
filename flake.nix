# flake.nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs.url = "github:serokell/deploy-rs";
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

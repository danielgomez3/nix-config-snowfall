# shells/dev.nix
# NOTE:
# This is my actual development shell configuration. Ideally, no .nix tools are needed on a system to deploy this flake, or just the justfile,  etc. All of that would be here.
{
  inputs,
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; {
  devShells.x86_64-linux.default = let
    pkgs = import inputs.nixpkgs {system = "x86_64-linux";};
  in
    pkgs.mkShell {
      packages = [
        inputs.deploy-rs.packages.${pkgs.system}.deploy-rs
        pkgs.just
      ];
      shellHook = ''alias d="deploy"'';
    };
}

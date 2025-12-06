# shells/deploy.nix
{
  inputs,
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; {
  devShells.x86_64-linux.deploy = let
    pkgs = import inputs.nixpkgs {system = "x86_64-linux";};
  in
    pkgs.mkShell {
      packages = [
        inputs.deploy-rs.packages.${pkgs.system}.deploy-rs
        pkgs.openssh
        pkgs.rsync
        pkgs.age
        pkgs.sops
      ];
      shellHook = ''
        alias d="deploy"
        echo "Deployment shell loaded"
      '';
    };
}

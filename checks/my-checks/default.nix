# checks/test-modules/default.nix
{
  lib,
  inputs,
  namespace,
  pkgs,
  ...
}:
pkgs.runCommand "test-modules" {
  # Dependencies available during the check
  buildInputs = [pkgs.jq pkgs.nix];
} ''
  # Your test logic here
  echo "Running module tests..."

  # Example: Check if a configuration builds
  # nix eval .#nixosConfigurations.laptop.config.system.build.toplevel.drvPath

  # If everything passes, create the output file
  echo "All tests passed!" > $out
''

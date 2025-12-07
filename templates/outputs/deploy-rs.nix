# deploy-rs.nix
# WIP:
{inputs, ...}: {
  #   deploy.nodes.test-machine = {
  #     hostname = "test-machine";
  #     sshUser = "root"; # username of the target machine
  #     fastConnection = true; # Enable pipelined copying
  #     profiles.system = {
  #       user = "root"; # The user that the profile will be deployed to
  #       path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos inputs.self.nixosConfigurations.test-machine;
  #     };
  #   };
  #   deploy.nodes.test = {
  #     hostname = "test";
  #     interactiveSudo = true;
  #     profiles.system = {
  #       user = "root";
  #       path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos inputs.self.nixosConfigurations.test;
  #     };
  #   };
}

# overlay/zjstatus/default.nix
{inputs, ...}: final: prev: {
  zjstatus = inputs.zjstatus.packages.${prev.system}.default;
}

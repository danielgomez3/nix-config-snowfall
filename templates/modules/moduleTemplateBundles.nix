# Module
# {lib, ...}: {
#   config = lib.mkIf cfg.enable {
#     myconfig.app.dependency.enable = true;
#     myconfig.services.related.enable = true;
#   };
# }

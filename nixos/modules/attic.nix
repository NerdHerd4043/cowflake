{
  config,
  lib,
  self,
  ...
}:

let
  cfg = config.herd.attic;
  inherit (lib)
    mkEnableOption
    mkIf
    ;
in
{
  options.herd.attic = {
    enable = mkEnableOption "herd attic";
  };

  config = mkIf cfg.enable {
    age.secrets.attic-env.file = "${self}/secrets/attic-env.age";

    services.atticd = {
      enable = true;
      environmentFile = config.age.secrets.attic-env.path;

      settings = {
        listen = "[::]:40431";
        api-endpoint = "https://nix.cache.nerdherd4043.org/";
        garbage-collection.default-retention-period = "1 month";
      };
    };

    services.nginx = {
      enable = true;
      virtualHosts = {
        "nix.cache.nerdherd4043.org" = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:40431";
          };
        };
      };
    };
  };
}

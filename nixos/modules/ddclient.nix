{
  config,
  lib,
  self,
  ...
}:
let
  cfg = config.herd.ddclient;
  inherit (lib)
    mkEnableOption
    mkIf
    ;
in
{
  options.herd.ddclient = {
    enable = mkEnableOption "herd ddclient module";
  };

  config = mkIf cfg.enable {
    age.secrets = {
      cf-dns-token.file = self + "/secrets/cf-dns-token.age";
    };

    services.ddclient = {
      enable = true;
      verbose = true;
      interval = "5min";
      ssl = true;
      usev4 = "webv4, webv4='https://cloudflare.com/cdn-cgi/trace', webv4-skip='ip= '";
      usev6 = "disabled";
      protocol = "cloudflare";
      zone = "nerdherd4043.org";
      username = "token";
      passwordFile = config.age.secrets.cf-dns-token.path;
      domains = [ config.networking.fqdn ];
    };
  };
}

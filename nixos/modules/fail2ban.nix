{ config, lib, ... }:
let
  cfg = config.herd.fail2ban;
  inherit (lib)
    mkEnableOption
    mkIf
    ;
in
{
  options.herd.fail2ban = {
    enable = mkEnableOption "fail2ban module";
  };

  config = mkIf cfg.enable {
    services.fail2ban = {
      enable = true;
      ignoreIP = [
        "192.168.1.0/24"
        "100.64.0.0/10" # Tailscale
      ];
      maxretry = 5;
      bantime-increment = {
        enable = true;
        overalljails = true;
        maxtime = "168h";
      };
    };
  };
}

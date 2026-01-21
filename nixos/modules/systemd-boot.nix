{ config, lib, ... }:

let
  cfg = config.herd.boot.systemd;
  inherit (lib)
    mkEnableOption
    mkIf
    ;
in
{
  options.herd.boot.systemd = {
    enable = mkEnableOption "herd boot.systemd";
  };

  config = mkIf cfg.enable {
    boot.loader = {
      grub.enable = false;
      systemd-boot = {
        enable = true;
        editor = false;
      };
    };
  };
}

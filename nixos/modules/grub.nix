{ config, lib, ... }:

let
  cfg = config.herd.boot.grub;
  inherit (lib)
    mkEnableOption
    mkIf
    ;
in
{
  options.herd.boot.grub = {
    enable = mkEnableOption "herd boot.grub";
  };

  config = mkIf cfg.enable {
    boot.loader.grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      splashImage = null;
    };
  };
}

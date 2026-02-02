{ config, lib, ... }:

let
  cfg = config.herd.desktop;
  inherit (lib)
    mkDefault
    mkEnableOption
    mkIf
    ;
in
{
  options.herd.desktop = {
    enable = mkEnableOption "herd desktop";
  };

  config = mkIf cfg.enable {
    herd = {
      audio.enable = mkDefault true;
      firefox.enable = mkDefault true;
      plymouth.enable = mkDefault true;
      printing.enable = mkDefault true;
    };

    hardware.bluetooth.enable = true;

    services.dbus.implementation = "broker";

    services.xserver.enable = true;
    services.displayManager.defaultSession = "cinnamon";
    services.xserver.displayManager.lightdm.enable = true;
    services.xserver.desktopManager.cinnamon.enable = true;
  };
}

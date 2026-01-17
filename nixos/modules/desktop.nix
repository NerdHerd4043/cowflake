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
      plymouth.enable = mkDefault true;
    };

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    # services.xserver.enable = mkDefault true;

    services.desktopManager.plasma6.enable = true;

    hardware.bluetooth.enable = true;

    services.dbus.implementation = "broker";
  };
}

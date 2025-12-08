{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.herd.ios-tether;
  inherit (lib)
    mkEnableOption
    mkIf
    ;
in
{
  options.herd.ios-tether = {
    enable = mkEnableOption "herd ios-tether" // {
      default = config.herd.networking.enable;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      libimobiledevice
    ];

    services.usbmuxd.enable = true;
  };
}

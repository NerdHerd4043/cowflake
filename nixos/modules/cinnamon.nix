{ config, lib, ... }:

let
  cfg = config.herd.cinnamon;
  inherit (lib)
    mkEnableOption
    mkIf
    ;
in
{
  options.herd.cinnamon = {
    enable = mkEnableOption "herd cinnamon";
  };

  config = mkIf cfg.enable {
    services.xserver.enable = true;
    services.displayManager.defaultSession = "cinnamon";
    services.xserver.displayManager.lightdm.enable = true;
    services.xserver.desktopManager.cinnamon.enable = true;

    programs.seahorse.enable = true;
    security.pam.services.login.enableGnomeKeyring = true;
    services.gnome.gnome-keyring.enable = true;
  };
}

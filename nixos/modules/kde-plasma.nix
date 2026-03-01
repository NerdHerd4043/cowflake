{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.herd.kde-plasma;
  inherit (lib)
    mkEnableOption
    mkIf
    ;
in
{
  options.herd.kde-plasma = {
    enable = mkEnableOption "herd kde-plasma";
  };

  config = mkIf cfg.enable {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    services.desktopManager.plasma6.enable = true;
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      plasma-browser-integration
    ];

    security.pam.services.login.kwallet.enable = true;
  };
}

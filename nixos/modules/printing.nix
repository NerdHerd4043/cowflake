{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.herd.printing;
  inherit (lib)
    mkEnableOption
    mkIf
    ;
in
{
  options.herd.printing = {
    enable = mkEnableOption "printing module";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      system-config-printer # GUI Config
      hplipWithPlugin # HP driver setup
    ];

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    services.ipp-usb.enable = true;

    # Enable CUPS to print documents.
    services.printing = {
      enable = true;
      drivers = with pkgs; [
        canon-capt
        canon-cups-ufr2
        cups-browsed
        cups-filters
        gutenprint
        gutenprintBin
        hplipWithPlugin
        ipp-usb
      ];
    };

    herd.packages.unfree.predicate = [
      "canon-cups-ufr2"
      "hplip"
    ];
  };
}

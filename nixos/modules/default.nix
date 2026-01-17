{
  config,
  lib,
  self,
  ...
}:
let
  cfg = config.herd;
  inherit (lib)
    mkDefault
    mkEnableOption
    mkIf
    mkOverride
    ;

  mkTrue = mkOverride 1100 true;

  # Takes the lastModifiedDate which is YYYYMMDDHHmmss
  # and converts it into YYYY-MM-DD.
  # Assumes source is entirely digits.
  date = lib.concatStringsSep "-" (lib.match "^(.{4})(.{2})(.{2}).*$" self.lastModifiedDate);
in
{
  imports = [
    ./acme.nix
    ./audio.nix
    ./boot.nix
    ./ddclient.nix
    ./ios-tether.nix
    ./minecraft-server.nix
    ./networking.nix
    ./nginx.nix
    ./nix.nix
    ./packages.nix
    ./site-preview.nix
    ./tailscale.nix
    ./wiki.nix
  ];

  options.herd.defaults = mkEnableOption "herd defaults" // {
    default = true;
  };

  config = {
    herd = mkIf cfg.defaults {
      boot.enable = mkTrue;
      networking.enable = mkTrue;
      nix.enable = mkTrue;
      packages.enable = mkTrue;
    };

    system.image = {
      id = mkDefault "cowflake";
      version = mkDefault "${date}-${self.shortRev or self.dirtyShortRev or "no-rev"}";
    };

    time.timeZone = "America/Los_Angeles";
    i18n.defaultLocale = "en_US.UTF-8";
  };
}

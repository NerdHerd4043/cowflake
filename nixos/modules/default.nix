{
  inputs,
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

  /**
    This creates a default "true" value that can be overridden by `lib.mkDefault true`, as:
    ```nix
    lib.mkDefault = lib.mkOverride 1000;
    lib.mkForce = lib.mkOverride 50;
    ```
  */
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
    ./fail2ban.nix
    ./grub.nix
    ./ios-tether.nix
    ./minecraft-server.nix
    ./networking.nix
    ./nginx.nix
    ./nix.nix
    ./packages.nix
    ./plymouth.nix
    ./site-preview.nix
    ./systemd-boot.nix
    ./tailscale.nix
    ./wiki.nix
    inputs.agenix.nixosModules.default
    inputs.disko.nixosModules.disko
  ];

  options.herd.defaults = mkEnableOption "herd defaults" // {
    default = true;
  };

  config = {
    herd = mkIf cfg.defaults {
      boot.enable = mkTrue;
      boot.grub.enable = mkTrue;
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

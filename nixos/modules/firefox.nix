{ config, lib, ... }:

let
  cfg = config.herd.firefox;
  inherit (lib)
    mkEnableOption
    mkIf
    ;
in
{
  options.herd.firefox = {
    enable = mkEnableOption "herd firefox";
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      preferences = {
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;
        "browser.urlbar.quicksuggest.dataCollection.enabled" = false;
      };

      # https://wiki.nixos.org/wiki/Firefox#Advanced
      languagePacks = [ "en-US" ];
      policies = {
        # Updates & Background Services
        AppAutoUpdate = false;
        BackgroundAppUpdate = false;

        # Feature Disabling
        DisableFirefoxStudies = true;
        DisableMasterPasswordCreation = true;
        DisableProfileImport = true;
        DisableProfileRefresh = true;
        DisableSetDesktopBackground = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DisableFormHistory = true;

        # Access Restrictions
        BlockAboutConfig = false;
        BlockAboutProfiles = true;

        # UI and Behavior
        DontCheckDefaultBrowser = true;
        OfferToSaveLogins = false;

        HttpsOnlyMode = "enabled";
        SanitizeOnShutdown = true;
        SkipTermsOfUse = true;

        # Extensions
        ExtensionSettings =
          let
            moz = short: "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpi";
          in
          {
            "uBlock0@raymondhill.net" = {
              install_url = moz "ublock-origin";
              installation_mode = "force_installed";
              updates_disabled = true;
            };
          };
      };
    };
  };
}

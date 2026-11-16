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
        DisableLaunchOnLogin = true;

        # Access Restrictions
        BlockAboutConfig = false;
        BlockAboutProfiles = true;

        # UI and Behavior
        DontCheckDefaultBrowser = true;
        OfferToSaveLogins = false;
        HttpsOnlyMode = "enabled";
        SanitizeOnShutdown = true;
        SkipTermsOfUse = true;
        OverrideFirstRunPage = "";

        # Disable Advertising and AI
        GenerativeAi.Enabled = false;
        AIControls.Default = false;
        FirefoxSuggest.WebSuggestions = false;
        FirefoxHome = {
          Highlights = false;
          Pocket = false;
          Snippets = false;
          Stories = false;
          TopSites = false;
          Widgets.Enabled = false;
        };

        # Extensions
        ExtensionSettings = {
          "uBlock0@raymondhill.net" = {
            installation_mode = "force_installed";
            default_area = "menupanel";
            private_browsing = true;
            updates_disabled = false;
          };
        };
      };
    };
  };
}

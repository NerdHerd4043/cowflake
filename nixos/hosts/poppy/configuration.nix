{ pkgs, ... }:
{
  imports = [
    ./disk-configuration.nix
    ./hardware-configuration.nix
  ];

  herd = {
    networking.wifi.enable = true;
    tailscale.enable = true;
  };

  networking.hostName = "poppy";

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      # For i5-6500T:
      intel-media-driver
    ];
  };

  users = {
    mutableUsers = false;
    users = {
      nerdherd4043 = {
        isNormalUser = true;
        extraGroups = [
          "networkManager"
          "video"
          "wheel"
        ];
        hashedPassword = "$y$j9T$BN5fvfmYxHqJVGoHUmle.0$fxCfLjaVXeRYRBB1Zju5OEQN.tNic88jyLq.wYbaqZD";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ3jJxl0RQclWmAUbA2/o5qvIt+yXzF+J3xkHQdr7PlP"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDwZSohB4Ub1uoMZ2rHM7zgK+oBl7CGakKQo3emz2z5b" # Bitwarden
        ];
      };
    };
  };

  programs.firefox = {
    enable = true;
    preferences = {
      "browser.sessionstore.resume_from_crash" = false;
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
      DisableFirefoxAccounts = true;
      DisableFirefoxScreenshots = true;
      DisableMasterPasswordCreation = true;
      DisableProfileImport = true;
      DisableProfileRefresh = true;
      DisableSetDesktopBackground = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DisableFormHistory = true;
      DisablePasswordReveal = true;

      # Access Restrictions
      BlockAboutConfig = false;
      BlockAboutProfiles = true;

      # UI and Behavior
      DisplayMenuBar = "never";
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

  environment.etc = {
    "cage-script/kiosk.sh" = {
      source = pkgs.writeShellScript "cage-script-kiosk" ''
        /run/current-system/sw/bin/firefox --kiosk "https://nerdherd4043.org/"
      '';
      mode = "0755";
    };
  };

  services.cage = {
    enable = true;
    program = "/etc/cage-script/kiosk.sh";
    extraArguments = [
      "-d" # Don't render client-side decorations
      "-m last" # Use only the last monitor connected
      "-s" # Allow TTY switching
    ];
    environment = {
      # WLR_LIBINPUT_NO_DEVICES = "1"; # Disable input devices (maybe?)
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_CRASHREPORTER_DISABLE = "1";
    };
    user = "nerdherd4043";
  };

  systemd.services = {
    "cage-tty1" = {
      # Wait 5 seconds to start the browser
      preStart = "sleep 5";
      # Always restart the browser when closed
      serviceConfig.Restart = "always";
    };
  };

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}

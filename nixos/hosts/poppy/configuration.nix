{ pkgs, lib, ... }:
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
          "networkmanager"
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

  # Allow unfree chromium package for WideVine
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "chromium"
      "chromium-unwrapped"
      "widevine-cdm"
    ];

  environment.systemPackages = with pkgs; [
    (chromium.override {
      enableWideVine = true;
      commandLineArgs = [
        # Enable Manifest V2 support for ublock origin
        "--disable-features=ExtensionManifestV2Unsupported,ExtensionManifestV2Disabled"
      ];
    })
  ];

  programs.chromium = {
    enable = true;
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm;https://clients2.google.com/service/update2/crx" # ublock origin
    ];
    extraOpts = {
      "BrowserSignin" = 0;
      "SyncDisabled" = true;
      "PasswordManagerEnabled" = false;
      "HttpsOnlyMode" = "force_enabled";
    };
  };

  environment.etc = {
    # Script that cage runs for kiosk mode.
    # Editable, but resets to the following on system build:
    "cage-script/kiosk.sh" = {
      source = pkgs.writeShellScript "cage-script-kiosk" ''

        URL="https://nerdherd4043.org/"

        /run/current-system/sw/bin/chromium --hide-scrollbars --kiosk "$URL"
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
      NIXOS_OZONE_WL = "1";
    };
    user = "nerdherd4043";
  };

  systemd.services = {
    "cage-tty1" = {
      # Always restart the browser when closed
      serviceConfig.Restart = "always";
    };
  };

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}

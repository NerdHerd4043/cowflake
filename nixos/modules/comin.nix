{ config, lib, ... }:

let
  cfg = config.herd.comin;
  inherit (lib)
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.herd.comin = {
    enable = mkEnableOption "herd comin";
    timeoutMin = mkOption {
      type = types.int;
      default = 30;
      description = "Maximum duration in minutes for a Nix build before comin cancels it.";
    };
    branches = {
      main.name = mkOption {
        default = "main";
        type = types.str;
      };
      testing.name = mkOption {
        default = "testing/${config.services.comin.hostname}";
        type = types.str;
      };
    };
  };

  config = mkIf cfg.enable {
    services.comin = {
      enable = true;
      remotes = [
        {
          name = "origin";
          url = "https://github.com/NerdHerd4043/cowflake.git";
          inherit (cfg) branches;
        }
      ];

      buildAttemptsLimit = 2;
      buildTimeout = mkDefault (cfg.timeoutMin * 60);
    };
  };
}

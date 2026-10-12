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
  };

  config = mkIf cfg.enable {
    services.comin = {
      enable = true;
      remotes = [
        {
          name = "origin";
          url = "https://github.com/NerdHerd4043/cowflake.git";
          branches = {
            main.name = "main";
            testing.name = "testing/${config.services.comin.hostname}";
          };
        }
      ];

      buildAttemptsLimit = 2;
      buildTimeout = mkDefault (cfg.timeoutMin * 60);
    };
  };
}

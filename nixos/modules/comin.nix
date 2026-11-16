{ config, lib, ... }:

let
  cfg = config.herd.comin;
  inherit (lib)
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    types
    recursiveUpdate
    ;

  branchesConfig = recursiveUpdate {
    main.name = "main";
    testing.name = "testing/${config.services.comin.hostname}";
  } cfg.branches;
in
{
  options.herd.comin = {
    enable = mkEnableOption "herd comin";
    timeoutMin = mkOption {
      type = types.int;
      default = 30;
      description = "Maximum duration in minutes for a Nix build before comin cancels it.";
    };
    branches = mkOption {
      type = with types; attrsOf anything;
      default = { };
      description = "Exposed options for services.comin.remotes.*.branches";
    };
  };

  config = mkIf cfg.enable {
    services.comin = {
      enable = true;
      remotes = [
        {
          name = "origin";
          url = "https://github.com/NerdHerd4043/cowflake.git";
          branches = branchesConfig;
        }
      ];

      buildAttemptsLimit = 2;
      buildTimeout = mkDefault (cfg.timeoutMin * 60);
    };
  };
}

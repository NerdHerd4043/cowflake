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
    branches = mkOption {
      type = with types; attrsOf anything;
      default = {
        main.name = "main";
        testing.name = "testing/${config.services.comin.hostname}";
      };
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
          inherit (cfg) branches;
        }
      ];

      buildAttemptsLimit = 2;
      buildTimeout = mkDefault (cfg.timeoutMin * 60);

      desktop = {
        enable = mkDefault config.herd.desktop.enable;
        title = "NixOS Updates (comin)";
      };
      buildConfirmer.mode = mkIf config.herd.desktop.enable "auto";
    };
  };
}

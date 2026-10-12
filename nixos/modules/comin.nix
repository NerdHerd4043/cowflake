{ config, lib, ... }:

let
  cfg = config.herd.comin;
  inherit (lib)
    mkEnableOption
    mkIf
    ;
in
{
  options.herd.comin = {
    enable = mkEnableOption "herd comin";
  };

  config = mkIf cfg.enable {
    services.comin = {
      enable = true;
      remotes = [
        {
          name = "origin";
          url = "https://github.com/NerdHerd4043/cowflake.git";
          branches.main.name = "main";
        }
      ];
    };
  };
}

{ config, lib, ... }:

let
  cfg = config.herd.boot;
  inherit (lib)
    mkEnableOption
    mkIf
    mkDefault
    ;
in
{
  options.herd.boot = {
    enable = mkEnableOption "herd boot";
  };

  config = mkIf cfg.enable {
    boot = {
      tmp = {
        useTmpfs = mkDefault true;
        cleanOnBoot = true;
      };

      loader = {
        timeout = 2;
        efi.canTouchEfiVariables = mkDefault true;
      };
    };
  };
}
